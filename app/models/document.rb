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
  
  has_many :collectible
  has_many :collection, through: :collectible
  
  acts_as_commentable
  
  validates_presence_of :user, :name, :state
  
  ROOT = "#{Rails.root}/public/documents"
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

  # Path convention for archives.
  # Local: /{Rails.root}/public/documents/:user_id/:year/:doc_id/:doc_name
  def archive_site
    # probably put this into "#{Rails.root}/tmp" for now, then send to S3 and record the S3 location

    # archive path should be to redis/elasticache
    archive_path = "#{self.user.id}/#{Time.now.strftime("%Y")}/#{id}/#{name.parameterize}"

    `httrack #{url} --depth=1 --path=#{ROOT}/#{archive_path}`
    
    # put in memcache or whatever, then:
    # `rm -rf #{ROOT}/#{archive_path}`

    `phantomjs #{Rails.root}/lib/js/rasterize.js #{url} #{ROOT}/#{archive_path}.png 950px*650px`

    generate_thumbnails( archive_path )

    `tar cvf - #{ROOT}/#{archive_path} | gzip > #{ROOT}/#{archive_path}.tar.gz`

    save_to_s3( "#{archive_path}.tar.gz" )
    
    self.file_location = "https://phaph.s3.amazonaws.com/#{archive_path}"
    self.save
  end

  def save_to_s3( path )
    s3 = AWS::S3.new
    bucket = s3.buckets['phaph'] # makes no request
    bucket = s3.buckets.create('phaph') unless bucket.exists?
    bucket.acl = :public_read
    bucket.objects["#{path}"].write(:file => "#{ROOT}/#{path}", :acl => :public_read)
  end

  def generate_thumbnails( path )
    image = MiniMagick::Image.open( "#{ROOT}/#{path}.png" )
    resize( path, 400  )
    resize( path, 225  )
    square( path, 75 )
  end

  def resize( path, size )
    image = MiniMagick::Image.open( "#{ROOT}/#{path}.png" )
    image.format( "gif" )
    image.resize( "#{size}x#{size}" )
    image.write "#{ROOT}/#{path}_#{size}.gif"
    save_to_s3( "#{path}_#{size}.gif" )
    return image
  end

  def square(path, size)
    i = MiniMagick::Image.open( "#{ROOT}/#{path}.png" )
    if i[:width] < i[:height]
      remove = ((i[:height] - i[:width])/2).round
      i.shave("0x#{remove}")
    elsif i[:width] > i[:height]
      remove = ((i[:width] - i[:height])/2).round
      i.shave("#{remove}x0")
    end
    i.resize("#{size}x#{size}")
    i.write "#{ROOT}/#{path}_#{size}.gif"
    save_to_s3( "#{path}_#{size}.gif" )
    return i
  end
  
end
