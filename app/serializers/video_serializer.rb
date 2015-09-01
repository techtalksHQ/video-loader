require_dependency "application_serializer"


module VideoLoader
  class VideoSerializer < ApplicationSerializer
    attributes :id, :title, :description, :url, :thumbnail_url
    attribute :publisher, :key => :publisher
    attribute :presenters, :key => :presenters

    def include_presenters?
      object.presenters
    end

    def include_publisher?
      object.publisher
    end
  end
end
