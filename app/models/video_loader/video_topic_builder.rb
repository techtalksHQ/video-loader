module VideoLoader
  class VideoTopicBuilder

    def initialize(tag, category, language, presenters, params, sources)
      @tag = tag
      @params = params
      @category = category
      @language = language
      @presenters = presenters
      @sources = sources || []
      @sources.to_a.push({:url => @params[:source_url], :type => get_source(@params[:source_url]), :download_only => false})
    end

    def create
      if !VideoLoader::video_exists?(@params[:source_url])
        video = ::VideoLoader::Video.create(:source_url => @params[:source_url],
                                            :title => @params[:title],
                                            :description => @params[:description],
                                            :thumbnail_url => @params[:thumbnail_url],
                                            :sources => JSON.generate(@sources),
                                            :presenters => @presenters.map { |s| get_presenter(s)},
                                            :publisher => build_publisher(@params[:source_url]))
        video.save
        build_topic(video, @params, [@language, @category, @tag])
      end
    end

    def get_source(url)
      url_re = /^https?:\/\/w?w?w?\.?(youtu|vimeo)/
      source = url_re.match(url)

      if source && source[1] == "youtu"
        return "youtube"
      elsif source && source[1] == "vimeo"
        return "vimeo"
      else
        return "other"
      end
    end

    def build_publisher(url)
      url_re = /^https?:\/\/w?w?w?\.?(youtu|vimeo)/
      source = url_re.match(url)

      if source == "youtube"
        response = Excon.get("https://www.youtube.com/oembed?url=#{url}&format=json")
      elsif source == "vimeo"
        response = Excon.get("https://vimeo.com/api/oembed.json?url=#{url}")
      else
        return
      end

      if response.status == 200
        body = JSON.parse(response.body)
        get_publisher(body["author_name"], body["author_url"])
      end
    end

    def get_publisher(name, url)
      publisher = ::VideoLoader::Publisher.where(:name => name).first_or_create
      publisher.url = url
      publisher.save
    end

    def get_presenter(name)
      ::VideoLoader::Presenter.where(:name => name).first_or_create
    end

    def build_topic(video, raw_data, tags, category="uncategorized", skip_validations=true)
      custom_fields = {"raw_data": raw_data, "tags": tags}
      args = {"title": video.title,
                :topic_id => nil,
                "raw": video.description,
                "category": category,
                :skip_validations => skip_validations}
      post = PostCreator.new(User.first, args).create
      post.topic.custom_fields = custom_fields
      post.topic.save_custom_fields(true)
      post.topic.video = video
      post.save
    end
  end
end