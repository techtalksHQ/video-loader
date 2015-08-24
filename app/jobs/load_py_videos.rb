module Jobs

  class LoadPyVideos < ::Jobs::Base

    def execute(url)
        response = Excon.get(url)
      if response.status == 200
        body = JSON.parse(response.body)
        parse_response(body["results"])
        Jobs.enqueue(:load_py_videos, body['next'] if body['next'])
      end
    end

    def build_author(url)
      #TODO: instead of include use regex
      if url.include?("youtube")
        response = Excon.get("https://youtube.com/oembed?url=#{url}&format=json")
        body = JSON.parse(response.body)
        name = body["author_name"]
        get_author(name)

      elsif url.include?("vimeo")

      end
    end

    def get_author(name)
      #CREATE AUTHOR MODEL
      Author.create() unless !!Author.find_by(:name => name).first
    end

    def source_url_exists?(url)
      !!TopicCustomField.find_by(:name => ‘source_url’, :value => url).first
    end

    def parse_response(results)
      result.each do |results|
        source_url = result['source_url']

        build_topic(source_url,
                    result['title'],
                    result['description'],
                    result) unless source_url_exists?(url)
      end
    end

    def build_topic(source_url, title, body, raw_data, category="uncategorized", skip_validations=true)
      custom_fields = {"source_url": source_url, "raw_data": raw_data}
      args = {"title": title,
                :topic_id => nil,
                "raw": body,
                "category": category,
                :skip_validations => skip_validations}
      post = PostCreator.new(User.first, args).create
      post.topic.custom_fields = custom_fields
      post.topic.save_custom_fields(true)
    end
  end
end
