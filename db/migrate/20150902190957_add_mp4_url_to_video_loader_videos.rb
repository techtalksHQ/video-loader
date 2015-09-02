class AddMp4UrlToVideoLoaderVideos < ActiveRecord::Migration
  def change
    add_column :video_loader_videos, :mp4_url, :string
  end
end
