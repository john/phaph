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
      indexes :journal, type: 'string'
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
      journal: journal,
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

  def archive_url
        

        # generate a web archive
        
        # /:user_id/:year/:document_id/:file_name

        # probably put this into "#{Rails.root}/tmp" for now, then send to S3 and record the S3 location
        docroot = "#{Rails.root}/public/documents"

        # archive path should be to redis/elasticache
        archive_path = "#{self.user.id}/#{Time.now.strftime("%Y")}/#{id}/#{name.parameterize}"

        `httrack #{url} --depth=1 --path=#{docroot}/#{archive_path}`
        `tar cvf - #{docroot}/#{archive_path} | gzip > #{docroot}/#{archive_path}.tar.gz`

        # put in memcache or whatever, then:
        # `rm -rf #{docroot}/#{archive_path}`

        bucket_name = 'phaph'
        file_name = "#{archive_path}.tar.gz"







        # api = YAML::load_file("#{Rails.root}/config/api_keys.yml")[Rails.env]
        # # AWS::S3::Base.establish_connection!(
        # #   :access_key_id => API['aws']['key'],
        # #   :secret_access_key => API['aws']['secret']
        # # )
        # AWS.config(:access_key_id => API['aws']['key'], :secret_access_key => API['aws']['secret'])


        # Get an instance of the S3 interface.
        s3 = AWS::S3.new

        # Upload a file.
        key = File.basename(file_name)
        s3.buckets[bucket_name].objects[key].write(:file => file_name)
        logger.debug "Uploading file #{file_name} to bucket #{bucket_name}."



        

        # `phantomjs rasterize.js http://fryolator.com #{Rails.root}/public/fryolator.png`
        # `phantomjs #{Rails.root}/lib/screenshot.js`
        `phantomjs #{Rails.root}/lib/js/rasterize.js #{url} #{docroot}/#{archive_path}.png 950px*650px`
  end
  
end
