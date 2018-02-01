class AddImageAttachmentToNeighborhoodLinks < ActiveRecord::Migration
  def change
  	add_attachment :neighborhood_links, :image
  end
end
