# From: https://github.com/elasticsearch/elasticsearch-rails/tree/master/elasticsearch-model

# drop index:
# Document.__elasticsearch__.client.indices.delete index: '_all'

# create index:
# Document.__elasticsearch__.create_index! force: true

class Document < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
   # self.per_page = 10
  
  attr_accessor :file_data
  
  # this shouldn't be necesary...
  after_commit on: [:update] do
    update_document
  end
  
  mount_uploader :file, FileUploader
  
  belongs_to :user
  belongs_to :organization
  
  validates_presence_of :user_id, :name, :state
  
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

  # def attachment
  #   path_to_attachment = self.file_url
  #   Base64.encode64(open( "#{Rails.root}/public#{path_to_attachment}" ) { |file| file.read })
  # end
  
  def attachment
    # path_to_attachment = self.file_url
    Base64.encode64( file_data )
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
  
end
