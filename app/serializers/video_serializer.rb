require_dependency "application_serializer"

module VideoLoader
  class VideoSerializer < ApplicationSerializer
    attributes :id, :title, :description, :source_url, :thumbnail_url, :sources
    attribute :publisher, :key => :publisher
    attribute :presenters, :key => :presenters

    def include_presenters?
      object.presenters
    end

    def include_publisher?
      object.publisher
    end

    def sources
      JSON.parse(object.sources)
    end
  end
end
