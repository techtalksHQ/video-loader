class CreateJoinTableVideoLoaderVideoPresenter < ActiveRecord::Migration
  def change
    create_join_table :videos, :presenters do |t|
      # t.index [:video_id, :presenter_id]
      # t.index [:presenter_id, :video_id]
    end
  end
end
