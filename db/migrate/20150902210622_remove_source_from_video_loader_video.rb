class RemoveSourceFromVideoLoaderVideo < ActiveRecord::Migration
  def change
    remove_column :video_loader_videos, :source
  end
end
