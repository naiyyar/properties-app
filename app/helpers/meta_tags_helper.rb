module MetaTagsHelper
  # def meta_title
  #   content_for?(:meta_title) ? content_for(:meta_title) : DEFAULT_META["meta_title"]
  # end

  # def meta_description
  #   content_for?(:meta_description) ? content_for(:meta_description) : DEFAULT_META["meta_description"]
  # end

  def seo_title_helper
    if featured_listing_show_page?
      ' | Apartment For Rent In NYC'
    else
      if search_page? || management_show_page? || home_page?
        ' | All No Fee Apartments'
      elsif building_show_page?
        ' | Transparentcity'
      end
    end
  end

  def seo_tab_title text
    content_for :page_title do 
      "#{text} | Transparentcity"
    end
  end
end