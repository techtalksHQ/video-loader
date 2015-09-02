class RemoveOgvUrlFromVideoLoaderVideo < ActiveRecord::Migration
  def change
    remove_column :video_loader_videos, :ogv_url
  end
end
