module VideoLoader
  class Publisher < ActiveRecord::Base
    has_many :video
  end
end
