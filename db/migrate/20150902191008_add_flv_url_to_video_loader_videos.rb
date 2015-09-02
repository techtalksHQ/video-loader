class AddFlvUrlToVideoLoaderVideos < ActiveRecord::Migration
  def change
    add_column :video_loader_videos, :flv_url, :string
  end
end
