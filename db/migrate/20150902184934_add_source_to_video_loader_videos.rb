class AddSourceToVideoLoaderVideos < ActiveRecord::Migration
  def change
    add_column :video_loader_videos, :source, :string
  end
end
