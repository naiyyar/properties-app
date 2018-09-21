# == Schema Information
#
# Table name: neighborhood_links
#
#  id                  :integer          not null, primary key
#  neighborhood        :string
#  date                :date
#  title               :string
#  web_url             :text
#  source              :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  image_file_name     :string
#  image_content_type  :string
#  image_file_size     :integer
#  image_updated_at    :datetime
#  parent_neighborhood :string
#

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
