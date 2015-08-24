class CreateVideoLoaderVideos < ActiveRecord::Migration
  def change
    create_table :video_loader_videos do |t|
      t.string :title
      t.string :url
      t.string :thumbnail
      t.string :description

      t.timestamps
    end
  end
end
