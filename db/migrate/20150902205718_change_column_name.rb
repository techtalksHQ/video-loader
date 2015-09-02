class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :video_loader_videos, :url, :source_url
  end
end
