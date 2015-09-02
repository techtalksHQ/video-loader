module Jobs

  class LoadPyVideos < ::Jobs::Base

    def execute(url)
      # "http://pyvideo.org/api/v2/video/?ordering=-added"
      response = Excon.get(url)

      if response.status == 200
        body = JSON.parse(response.body)
        results = body['results']

        # if body["next"] && !video_exists?(results[-1]['source_url'])
        #   ::Jobs.enqueue(:load_py_videos, body['next'])
        # end

        results.each do|result|
          if !video_exists?(result['source_url'])
            language = "LANG_" + result['language']
            build_topic(parse_response(result), result, [language, 'python', result['category']])
          end
        end
      end
    end

    def parse_response(result)
      ::VideoLoader::Video.create(:url => result['source_url'],
                                  :title => result['title'],
                                  :description => result['summary'],
                                  :thumbnail_url => result['thumbnail_url'],
                                  :presenters => result['speakers'].map { |s| get_presenter(s)},
                                  :publisher => build_publisher(result['source_url']))
    end


    #TODO: Move all of this into its own class:

    def build_publisher(url)
      url_re = /^https?:\/\/w?w?w?\.?(youtu|vimeo)/
      source = url_re.match(url)

      if source && source[1] == "youtu"
        response = Excon.get("https://www.youtube.com/oembed?url=#{url}&format=json")
      elsif source && source[1] == "vimeo"
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

    def video_exists?(url)
      !!::VideoLoader::Video.where(:url => url).first
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
