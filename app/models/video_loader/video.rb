module VideoLoader
  class Video < ActiveRecord::Base
    belongs_to :publisher
    belongs_to_and_has_many :video_loader_presenter
  end
end
