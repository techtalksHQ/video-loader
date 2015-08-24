module VideoLoader
  class Video < ActiveRecord::Base
    belongs_to :author
    belongs_to :publisher
  end
end
