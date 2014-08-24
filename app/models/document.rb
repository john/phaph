# From: https://github.com/elasticsearch/elasticsearch-rails/tree/master/elasticsearch-model

# drop index:
# Document.__elasticsearch__.client.indices.delete index: '_all'

# create index:
# Document.__elasticsearch__.create_index! force: true

class Document < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
  attr_accessor :collection_id
  attr_accessor :file_data
  
  # this shouldn't be necesary...
  after_commit on: [:update] do
    update_document
  end
  
  mount_uploader :file, FileUploader
  
  belongs_to :organization
  belongs_to :user
  
  has_many :collectibles
  has_many :collections, through: :collectibles
  
  acts_as_commentable
  
  validates_presence_of :user, :name, :state
  
  ROOT = "#{Rails.root}/public"
  STATES = [:active, :inactive]
  state_machine :state, :initial => :active do
    event :deactivate do transition STATES => :inactive end
    event :activate do transition STATES => :active end
  end
  
  MIME_TYPES = ['application/pdf', 'application/rtf',
    'text/plain', 'text/html',
    'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.template',
    'application/vnd.ms-word.document.macroEnabled.12',
    'application/vnd.ms-word.template.macroEnabled.12',
    'application/vnd.ms-powerpoint',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'application/vnd.openxmlformats-officedocument.presentationml.template',
    'application/vnd.openxmlformats-officedocument.presentationml.slideshow',
    'application/vnd.ms-powerpoint.addin.macroEnabled.12',
    'application/vnd.ms-powerpoint.presentation.macroEnabled.12',
    'application/vnd.ms-powerpoint.template.macroEnabled.12',
    'application/vnd.ms-powerpoint.slideshow.macroEnabled.12'
  ]
  
  settings index: { number_of_shards: 5, number_of_replicas: 1 } do
    mappings do
      indexes :user_id, type: 'integer', index: :not_analyzed
      indexes :organization_id, type: 'integer', index: :not_analyzed
      indexes :name, type: 'string'
      indexes :description, type: 'string'
      indexes :source, type: 'string'
      # indexes :journal, type: 'string'
      indexes :principle_authors, type: 'string'
      indexes :other_authors, type: 'string'
      indexes :rights, type: 'string'
      indexes :created_at, type: 'date'
      indexes :updated_at, type: 'date'
      indexes :attachment, type: 'attachment', fields: {
        attachment: {
          term_vector: 'with_positions_offsets',
          store: true
        }
      }
    end
  end

  def attachment
    Base64.encode64( file_data ) if file_data.present?
  end
  
  def as_indexed_json(options={})
    # to_json(:methods => [:attachment])
    {
      name: name,
      description: description,
      source: source,
      # journal: journal,
      principle_authors: principle_authors,
      other_authors: other_authors,
      rights: rights,
      user_id: user_id,
      organization_id: organization_id,
      created_at: created_at,
      updated_at: updated_at,
      attachment: attachment
    }
  end

  def archive_path
    # TODO: this incrementation crap looks fragile. How can we get the object id before the object is persisted?
    the_id = (id.blank?) ? (Document.maximum(:id) + 1) : id
    "documents/1/#{Time.now.strftime("%Y")}/#{the_id}"
  end

  # Path convention for archives.
  # Local: /{Rails.root}/public/documents/:user_id/:year/:doc_id/:doc_name
  def archive_site
    # probably put this into "#{Rails.root}/tmp" for now, then send to S3 and record the S3 location
    `httrack #{url} --depth=1 --path=#{ROOT}/#{archive_path}/#{name.parameterize}`
    
    # put in memcache or whatever, then:
    # `rm -rf #{ROOT}/#{archive_path}`

    `tar cvf - #{ROOT}/#{archive_path} | gzip > #{ROOT}/#{archive_path}/#{name.parameterize}.tar.gz`
    save_to_s3 "#{archive_path}/#{name.parameterize}.tar.gz"

    self.file_location = "https://phaph.s3.amazonaws.com/#{archive_path}/#{name.parameterize}.tar.gz"
    self.save

    `phantomjs #{Rails.root}/lib/js/rasterize.js #{url} #{ROOT}/#{archive_path}/#{name.parameterize}.png 950px*650px`
    # screenshot has been generated, jack a message into the dom:
    # IA does this: https://web.archive.org/web/20061231032842/http://wordie.org/?
    generate_thumbnails( self, "#{archive_path}/#{name.parameterize}" )
    self.save
  end

  def archive_file
    # move uploaded file to S3

    logger.debug "----> IN archive_file, saving to s3: #{self.file.path}"


    save_to_s3 "#{archive_path}/#{File.basename(self.file.path)}"

    # records it's location on S3
    self.file_location = "https://phaph.s3.amazonaws.com/#{archive_path}/#{File.basename(self.file.path)}"
    self.save

    # generate a full-sized png from the pdf
    image = MiniMagick::Image.open("#{ROOT}/#{archive_path}/#{File.basename(self.file.path)}")
    # image = Magick::ImageList.new("#{ROOT}/#{archive_path}/#{File.basename(self.file.path)}[0]").first
    image.format("png", 0)
    image.resize("950x")
    image.write("#{ROOT}/#{archive_path}/#{name.parameterize}.png")

    generate_thumbnails( self, "#{archive_path}/#{name.parameterize}" )
    self.save
  end

  def generate_thumbnails( doc, path )
    resize( doc, path, 400, 'lg'  )
    resize( doc, path, 225, 'md'  )
    square( doc, path, 75, 'sm' )
  end

  def resize( doc, path, size, suffix )
    format = 'png'
    image = MiniMagick::Image.open( "#{ROOT}/#{path}.#{format}" )
    image.format( format )
    image.resize( "#{size}x#{size}" )
    image.write "#{ROOT}/#{path}_#{suffix}.#{format}"
    doc.send( "thumb_#{suffix}=", "#{path}_#{suffix}.#{format}" )
    save_to_s3( "#{path}_#{suffix}.#{format}" )
    return image
  end

  def square( doc, path, size, suffix )
    format = 'png'
    i = MiniMagick::Image.open( "#{ROOT}/#{path}.#{format}" )
    if i[:width] < i[:height]
      remove = ((i[:height] - i[:width])/2).round
      i.shave("0x#{remove}")
    elsif i[:width] > i[:height]
      remove = ((i[:width] - i[:height])/2).round
      i.shave("#{remove}x0")
    end
    i.resize( "#{size}x#{size}" )
    i.write "#{ROOT}/#{path}_#{suffix}.#{format}"
    doc.send( "thumb_#{suffix}=", "#{path}_#{suffix}.#{format}" )
    save_to_s3( "#{path}_#{suffix}.#{format}" )
    return i
  end

  def save_to_s3( path )
    logger.debug "----> IN save_to_s3, ROOT: #{ROOT}"
    logger.debug "----> IN save_to_s3, path: #{path}"
    logger.debug "----> IN save_to_s3, full: #{ROOT}/#{path}"
    s3 = AWS::S3.new
    bucket = s3.buckets['phaph'] # makes no request
    bucket = s3.buckets.create('phaph') unless bucket.exists?
    bucket.acl = :public_read

    path[0] = '' if path[0] == '/'
    bucket.objects["#{path}"].write(:file => "#{ROOT}/#{path}", :acl => :public_read)
  end
  
end
