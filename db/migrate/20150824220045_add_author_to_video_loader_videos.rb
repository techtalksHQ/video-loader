class AddAuthorToVideoLoaderVideos < ActiveRecord::Migration
  def change
    add_reference :video_loader_videos, :author, index: true
  end
end
