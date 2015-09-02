class RemoveFlvUrlFromVideoLoaderVideo < ActiveRecord::Migration
  def change
    remove_column :video_loader_videos, :flv_url
  end
end
