module VideoLoader
  class Video < ActiveRecord::Base
    belongs_to :publisher
    has_and_belongs_to_many :presenters
    belongs_to :topic
  end
end
