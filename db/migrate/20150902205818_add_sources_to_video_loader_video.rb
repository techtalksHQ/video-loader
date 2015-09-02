class AddSourcesToVideoLoaderVideo < ActiveRecord::Migration
  def change
     add_column :video_loader_videos, :sources, :text
  end
end
