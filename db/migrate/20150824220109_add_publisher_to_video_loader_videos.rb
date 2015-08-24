class AddPublisherToVideoLoaderVideos < ActiveRecord::Migration
  def change
    add_reference :video_loader_videos, :publisher, index: true
  end
end
