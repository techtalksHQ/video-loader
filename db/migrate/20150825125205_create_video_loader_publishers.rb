class CreateVideoLoaderPublishers < ActiveRecord::Migration
  def change
    create_table :video_loader_publishers do |t|
      t.string :name
      t.string :image_url
      t.text :description

      t.timestamps
    end
  end
end
