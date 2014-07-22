class Document < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
  # # this shouldn't be necesary...
  # after_commit on: [:update] do
  #   update_document
  # end
    
  mount_uploader :file, FileUploader
  
  belongs_to :user
  belongs_to :lab
  
  validates :name, presence: true
  validates :lab_id, presence: true
  
  STATES = [:active, :inactive]
  state_machine :state, :initial => :active do
    event :deactivate do transition STATES => :inactive end
    event :activate do transition STATES => :active end
  end
  
  # From: https://github.com/elasticsearch/elasticsearch-rails/tree/master/elasticsearch-model
  # Document.__elasticsearch__.create_index!
  settings index: { number_of_shards: 5, number_of_replicas: 1 } do
    mappings do
      indexes :name, type: 'string'
      indexes :description, type: 'string'
      indexes :source, type: 'string'
      indexes :journal, type: 'string'
      indexes :principle_authors, type: 'string'
      indexes :other_authors, type: 'string'
      indexes :rights, type: 'string'
      indexes :user_id, type: 'integer'
      indexes :lab_id, type: 'integer'
      indexes :grant_id, type: 'integer'
      indexes :created_at, type: 'date'
      indexes :updated_at, type: 'date'
      indexes :attachment, type: 'attachment'
    end
  end

  def attachment
    path_to_attachment = self.file_url
    Base64.encode64(open( "#{Rails.root}/public#{path_to_attachment}" ) { |file| file.read })
  end
  
  # # # def to_indexed_json
  # # #   to_json(methods: [:attachment])
  # # # end
  # def as_indexed_json(options={})
  #   self.as_json(
  #     include: { attachment: { methods: [:attachment] } }
  #   )
  # end
  
  def as_indexed_json(options={})
    # self.as_json(
    #   only: [:name],
    #   methods: [:attachment]
    # )
    {
      name: name,
      description: description,
      source: source,
      journal: journal,
      principle_authors: principle_authors,
      other_authors: other_authors,
      rights: rights,
      user_id: user_id,
      lab_id: lab_id,
      grant_id: grant_id,
      created_at: created_at,
      updated_at: updated_at,
      attachment: attachment
    }
  end
  
  # def nameplus
  #   "foobar"
  # end
  
end
