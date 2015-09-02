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
          if !VideoLoader::video_exists?(result['source_url'])
            parse_response(result)
          end
        end
      end
    end

    def parse_response(result)
      tag =  result['category']
      category = "python"
      language = "lang_"+result["language"]
      presenters = result['speakers'] || []
      params = {:url => result['source_url'],
                :description => result['summary'],
                :mp4_url => result['video_mp4_url'],
                :ogv_url => result['video_ogv_url'],
                :flv_url => result['flv_url']}
      ::VideoLoader::VideoTopicBuilder.new(tag, category, language, presenters, params).create
    end
  end
end
