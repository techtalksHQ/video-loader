class CreateVideoLoaderVideos < ActiveRecord::Migration
  def change
    create_table :video_loader_videos do |t|
      t.string :title
      t.string :url
      t.string :thumbnail_url
      t.string :description
      t.references :publisher, index: true

      t.timestamps
    end
  end
end
