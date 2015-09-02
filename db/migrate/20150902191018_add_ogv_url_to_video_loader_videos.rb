class AddOgvUrlToVideoLoaderVideos < ActiveRecord::Migration
  def change
    add_column :video_loader_videos, :ogv_url, :string
  end
end
