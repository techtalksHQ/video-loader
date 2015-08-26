require File.expand_path('../video_loader/engine', __FILE__)

module VideoLoader

   module AddVideoToTopic
    def self.included(klass)
      klass.has_one :video, class_name: '::VideoLoader::Video'
    end
  end

end
