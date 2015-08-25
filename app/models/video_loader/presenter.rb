module VideoLoader
  class Presenter < ActiveRecord::Base
    belongs_to_and_has_many :video_loader_video
  end
end
