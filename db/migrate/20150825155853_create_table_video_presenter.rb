class CreateTableVideoPresenter < ActiveRecord::Migration
  def change
    create_table :video_loader_presenters_videos, id: false do |t|
      t.belongs_to :video, index: true
      t.belongs_to :presenter, index: true
    end
  end
end
