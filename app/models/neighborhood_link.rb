class NeighborhoodLink < ActiveRecord::Base

	has_attached_file :image, 
                    :styles => { :medium => "300x300>", :thumb => "100x100>", :original => '' }
	
	validates_attachment :image,
                			:content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] }


  default_scope { order('date desc, title ASC') }

  def link_image
  	self.image.present? ? self.image : 'missing-grey.png'
  end

  def save_parent_neighborhood
  	buildings = Building.where('neighborhoods_parent is not null and neighborhood = ?', self.neighborhood)
  	self.update(parent_neighborhood: buildings.first.neighborhoods_parent) if buildings.present?
  end

  def self.neighborhood_guide_links(search_string, queens_borough)
    if search_string.present? and search_string == 'New York'
      @neighborhood_links = NeighborhoodLink.all
    elsif queens_borough.include?(search_string)
      @neighborhood_links = NeighborhoodLink.where('neighborhood = ?', search_string)
    else
      @neighborhood_links = NeighborhoodLink.where('neighborhood @@ :q or parent_neighborhood @@ :q', q: search_string)
    end
  end

end
