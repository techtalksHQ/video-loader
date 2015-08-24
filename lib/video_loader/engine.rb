module VideoLoader
  class Engine < ::Rails::Engine
    isolate_namespace VideoLoader

    config.after_initialize do
      require_relative '../../app/jobs/load_py_videos'
      Discourse::Application.routes.append do
        mount VideoLoader::Engine, at: 'video_loader'
        # mounting answers acceptance on a different path to stay API compatible
        # with the official discourse-answer plugin:
        #  https://github.com/discourse/discourse-accepted-answer/blob/master/plugin.rb#L57-L59
      end
    end

    config.to_prepare do
      # inject our dependencies
      # runs once in production, before every request in development
      end

  end
end

