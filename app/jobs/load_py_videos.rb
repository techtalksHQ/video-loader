module Jobs

  class LoadPyVideos < ::Jobs::Base

    def execute(url)
        response = Excon.get("http://pyvideo.org/api/v2/video/?ordering=-added")
      if response.status == 200
        body = JSON.parse(response.body)
        # puts body["results"]
        parse_response(body["results"])
        # Jobs.enqueue(:load_py_videos, body['next'] if body['next'])
      end
    end

    def build_publisher(url)
      #TODO: instead of include use regex
      if url.include?("youtube")
        response = Excon.get("https://youtube.com/oembed?url=#{url}&format=json")
        body = JSON.parse(response.body)
        name = body["author_name"]
        get_presenter(name)

      elsif url.include?("vimeo")

      end
    end

    def get_publisher(name, description="", image="")
      ::VideoLoader::Publisher.where(:name => name).first_or_create
    end

    def get_presenter(name)
      ::VideoLoader::Presenter.where(:name => name).first_or_create
    end

    def get_video(url)
      ::VideoLoader::Video.where(:url => url).first_or_create
    end

    def parse_response(results)
      results.each do |result|
        video = get_video(result['source_url'])
        video.title = result['title']
        video.description = result['summary']
        video.thumbnail_url = result['thumbnail_url']
        video.presenters = result['speakers'].map { |s| get_presenter(s)}
        video.save

        build_topic(video, result)
      end
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
      post.topic.video = video
      post.topic.save_custom_fields(true)
    end
  end
end
