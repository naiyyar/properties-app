class NeighborhoodLink < ActiveRecord::Base

	has_attached_file :image, 
                    :styles => { :medium => "300x300>", :thumb => "100x100>", :original => '' }
	
	validates_attachment :image,
                			:content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] }




  def link_image
  	self.image.present? ? self.image : 'missing-grey'
  end

end
