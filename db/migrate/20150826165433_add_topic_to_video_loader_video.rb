class AddTopicToVideoLoaderVideo < ActiveRecord::Migration
  def change
    add_reference :video_loader_videos, :topic, index: true, foreign_key: true
  end
end
