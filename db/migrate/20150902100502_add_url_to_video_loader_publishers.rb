class AddUrlToVideoLoaderPublishers < ActiveRecord::Migration
  def change
    add_column :video_loader_publishers, :url, :string
  end
end
