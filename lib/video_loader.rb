require File.expand_path('../video_loader/engine', __FILE__)

module VideoLoader

   module AddVideoToTopic
    def self.included(klass)
      klass.has_one :video, class_name: '::VideoLoader::Video'
    end
  end

  module ExtendTopicViewSerializer
    def self.included(klass)
      klass.attributes :video
    end

    def video
      VideoLoader::VideoSerializer.new(object.topic.video, root: false, scope: scope)
    end

    def include_video?
      object.topic.video
    end
  end

end
