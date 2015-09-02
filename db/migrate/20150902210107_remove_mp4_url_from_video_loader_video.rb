class RemoveMp4UrlFromVideoLoaderVideo < ActiveRecord::Migration
  def change
    remove_column :video_loader_videos, :mp4_url
  end
end
