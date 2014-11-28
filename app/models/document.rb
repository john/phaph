# From: https://github.com/elasticsearch/elasticsearch-rails/tree/master/elasticsearch-model

# reset db then start console:
# be rake db:drop; rake db:create; rake db:migrate; rails c

# drop index:
# Document.__elasticsearch__.client.indices.delete index: '_all'

# create index:
# Document.__elasticsearch__.create_index! force: true

class Document < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  # include PublicActivity::Common

  extend FriendlyId
  friendly_id :name, use: :slugged
  
  mount_uploader :file, FileUploader
  
  belongs_to :organization
  belongs_to :user
  
  # has_many :collectibles
  # has_many :collections, through: :collectibles
  has_one :collectible
  has_one :collection, through: :collectible
  
  validates_presence_of :user, :name, :state
  
  enum state: { active: 0, inactive: 1 }
  
  attr_accessor :description
  attr_accessor :description
  attr_accessor :collection_id
  attr_accessor :file_data
  
  # # this shouldn't be necesary, but elasticsearch-ruby doesn't seem to be persistingn to es all the time
  # after_commit on: [:update] do
  #   logger.debug "-------------------------------> CALLING update_document."
  #   update_document
  # end
  
  # before_destroy do |record|
  #   # # Person.destroy_all "firm_id = #{record.id}"
  #   # record.delete_files
  #   # record.remove_from_s3
  # end

  ROOT = "#{Rails.root}/public"
  FQDN = 'https://phaph.s3.amazonaws.com'
  
  settings index: { number_of_shards: 5, number_of_replicas: 1 } do
    mappings do
      indexes :user_id, type: 'integer', index: :not_analyzed
      indexes :name, type: 'string'
      indexes :source, type: 'string'
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
    if file_data.present?
      Base64.encode64( file_data )
    else
      Base64.encode64('')
    end
  end
  
  def as_indexed_json(options={})
    # to_json(:methods => [:attachment])
    {
      name: name,
      source: source,
      # journal: journal,
      principle_authors: principle_authors,
      other_authors: other_authors,
      rights: rights,
      user_id: user_id,
      created_at: created_at,
      updated_at: updated_at,
      attachment: attachment
    }
  end

  # def archive_path
  #   # TODO: this incrementation crap is jank. How can we get the object id before the object is persisted?
  #   # Rails 4.2 GUID?
  #   the_id = (id.blank?) ? (Document.maximum(:id) + 1) : id
  #
  #   # "documents/1/#{Time.now.strftime("%Y")}/#{the_id}"
  #   "#{current_user.id}/#{the_id}"
  # end

  # for archiving a website. use archive_file to do the same for an uploaded file
  def archive_site
    doc_id = (id.blank?) ? (Document.maximum(:id) + 1) : id
    
    httrack_call = "httrack #{url} --depth=1 --path=/tmp/#{doc_id}/#{slug}"
    out = `#{httrack_call}`

    out = `tar -cvzf /tmp/#{doc_id}/#{slug}.tar.gz /tmp/#{doc_id}/#{slug}`
    save_to_s3( "/tmp/#{doc_id}/#{slug}.tar.gz", "#{doc_id}/#{slug}.tar.gz" )
    
    self.file_location = "/#{doc_id}/#{slug}.tar.gz"
    self.save

    phantom_call = "phantomjs #{Rails.root}/lib/js/rasterize.js #{url} /tmp/#{doc_id}/#{slug}.png 950px*650px"
    logger.info "-----------> phantom_call: #{phantom_call}"
    out = `#{phantom_call}`
    logger.info "-----------> phantom out: #{out}"
    
    # screenshot has been generated, jack a message into the dom:
    # IA does this: https://web.archive.org/web/20061231032842/http://wordie.org/?
    
    generate_thumbnails( self, "/tmp/#{doc_id}/#{slug}" )
    self.save
  end

  # def archive_file
  #   # full_path = "#{ROOT}/#{archive_path}"
  #   filename = File.basename(self.file.path)
  #   save_to_s3 "#{archive_path}/#{filename}"
  #
  #   self.file_location = "#{Document::FQDN}/#{archive_path}/#{filename}"
  #   self.save
  #
  #   unless self.pdf?
  #
  #     # Might want to install the latest unoconv from git, the one installed by brew was out of date and broken
  #
  #
  #     unoconv_call = "unoconv -f pdf -o /tmp '#{full_path}/#{filename}'"
  #     logger.info "-----------> unoconv_call: #{unoconv_call}"
  #     out = `#{unoconv_call}`
  #     logger.info "-----------> unoconv out: #{out}"
  #
  #     pdf_path = "/tmp/#{filename.split('.')[-2]}.pdf"
  #   else
  #     pdf_path = "#{full_path}/#{filename}"
  #   end
  #
  #   # generate a full-sized png from the pdf
  #   image = MiniMagick::Image.open( pdf_path )
  #   image.format("png", 0)
  #   image.resize("950x")
  #   image.write("#{full_path}/#{slug}.png")
  #
  #   generate_thumbnails( self, "#{archive_path}/#{slug}" )
  #   self.save
  # end

  def pdf?
    fm = FileMagic.new
    file_info = fm.file("#{ROOT}/#{archive_path}/#{File.basename(self.file.path)}")
    file_info.include?( "PDF document")
  end

  def generate_thumbnails( doc, path )
    resize( doc, path, 400, 'lg'  )
    resize( doc, path, 225, 'md'  )
    square( doc, path, 75, 'sm' )
  end

  def resize( doc, path, size, suffix )
    format = 'png'
    image = MiniMagick::Image.open( "#{path}.#{format}" )
    image.format( format )
    image.resize( "#{size}x#{size}" )
    image.write "#{path}_#{suffix}.#{format}"
    doc.send( "thumb_#{suffix}=", "/#{path}_#{suffix}.#{format}" )
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
    doc.send( "thumb_#{suffix}=", "/#{path}_#{suffix}.#{format}" )
    save_to_s3( "#{path}_#{suffix}.#{format}" )
    return i
  end

  def save_to_s3( local_path, remote_path )
    s3 = AWS::S3.new
    bucket = s3.buckets['phaph'] # makes no request
    bucket = s3.buckets.create('phaph') unless bucket.exists?
    bucket.acl = :public_read
    
    # filename = File.basename(path)
    
    # path[0] = '' if path[0] == '/'
    # bucket.objects["#{path}"].write(:file => "#{ROOT}/#{path}", :acl => :public_read)
    bucket.objects[remote_path].write(:file => local_path, :acl => :public_read)
  end

  # def remove_from_s3
  #   s3 = AWS::S3.new
  #   bucket = s3.buckets['phaph']
  #   sm = thumb_sm
  #   sm[0] = ''
  #   md = thumb_md
  #   md[0] = ''
  #   lg = thumb_lg
  #   lg[0] = ''
  #   fle = file_location
  #   fle[0] = ''
  #
  #   logger.debug "------------------------> ABOUT to remove three thumbs"
  #   bucket.objects.delete( sm, md, lg, fle )
  # end

  # def delete_files
  #   directory = File.dirname( "#{Rails.root}/public#{file_location}" )
  #   logger.debug "------------------------> dir to delete: #{directory}"
  #
  #   parent_directory = File.dirname( directory )
  #
  #   FileUtils.rm_rf( directory )
  #
  #   recursively_delete_empty_directories( parent_directory )
  # end

  # def recursively_delete_empty_directories(directory)
  #   if (Dir.entries(directory) - %w{ . .. }).empty?
  #     logger.debug "------------------------> dir to delete: #{directory}"

  #     parent_directory = File.dirname( directory )
  #     FileUtils.rm_rf( directory )
  #     recursively_delete_empty_directories(parent_directory)
  #   end
  # end
  
end
