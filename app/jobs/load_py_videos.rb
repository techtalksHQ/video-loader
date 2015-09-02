module Jobs

  class LoadPyVideos < ::Jobs::Base

    def execute(url)
      # "http://pyvideo.org/api/v2/video/?ordering=-added&page=5"
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
      presenters = result['speakers']
      sources = get_sources(result)
      params = {source_url: result['source_url'],
                description: result['summary'],
                title: result['title'],
                thumbnail_url: result['thumbnail_url']}

      ::VideoLoader::VideoTopicBuilder.new(tag, category, language, presenters, params, sources).create
    end

    def get_sources(result)
      sources = []
      types = ['mp4', 'ogv', 'flv']

      types.each do |type|
        url_str = "video_#{type}_url"
        download_str = "video_#{type}_download_only"

        if !!result[url_str] and result[url_str].size > 0
          sources += [{'url': result[url_str],
                        'download_only': result[download_str],
                        'type': type}]
        end
      end
      return sources
    end
  end
end
