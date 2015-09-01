module Jobs

  class LoadPyVideos < ::Jobs::Base

    def execute(url)
      # "http://pyvideo.org/api/v2/video/?ordering=-added"
      response = Excon.get(url)

      if response.status == 200
        body = JSON.parse(response.body)
        results = body['results']

        if body["next"] && !video_exists?(results[-1]['source_url'])
          ::Jobs.enqueue(:load_py_videos, body['next'])
        end

        results.each do|result|
          if !video_exists?(result['source_url'])
            build_topic(parse_response(result), result)
          end
        end
      end
    end

    def parse_response(result)
      ::VideoLoader::Video.create(:url => result['source_url'],
                                  :title => result['title'],
                                  :description => result['summary'],
                                  :thumbnail_url => result['thumbnail_url'],
                                  :presenters => result['speakers'].map { |s| get_presenter(s)})
    end


    #TODO: Move all of this into its own class:

    def build_publisher(url)
      url_re = /^https?:\/\/(youtu|vimeo)/
      source = url_re.match(url)
      if source && source[1] == "youtu"
        response = Excon.get("https://youtube.com/oembed?url=#{url}&format=json")
        body = JSON.parse(response.body)
        name = body["author_name"]
        get_presenter(name)

      elsif source && source[1] == "vimeo"
        #Go get data from Vimeo
      else
        return
      end
    end

    def get_publisher(name, description="", image="")
      ::VideoLoader::Publisher.where(:name => name).first_or_create
    end

    def get_presenter(name)
      ::VideoLoader::Presenter.where(:name => name).first_or_create
    end

    def video_exists?(url)
      !!::VideoLoader::Video.where(:url => url).first
    end

    def build_topic(video, raw_data, category="uncategorized", skip_validations=true)
      custom_fields = {"raw_data": raw_data}
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
