# Set the host name for URL creation
#require 'aws-sdk'
SitemapGenerator::Sitemap.default_host = "http://aptreviews.herokuapp.com"
SitemapGenerator::Sitemap.create_index = true
SitemapGenerator::Sitemap.compress = false
SitemapGenerator::Sitemap.sitemaps_host = "https://s3-us-west-2.amazonaws.com/#{ENV['AWS_S3_BUCKET']}/"
SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/"
#SitemapGenerator::Sitemap.public_path = 'public/sitemaps/'

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  add root_path
  add buildings_path

  Neighborhood.find_each do |nb|
    add search_path(:searched_by => 'no-fee-apartments-nyc-neighborhoods', search_term: nb.formatted_name), lastmod: nb.updated_at, changefreq: 'weekly', priority: 1.0
  end
  
  Building.find_each do |building|
    add building_path(building), lastmod: building.updated_at
    add search_path(:searched_by => 'zipcode', search_term: building.zipcode), lastmod: Time.now, changefreq: 'weekly', priority: 1.0
  end

  add management_companies_path

  ManagementCompany.find_each do |company|
    add no_fee_company_path(id: company), lastmod: company.updated_at
  end
  
  add units_path
  Unit.find_each do |unit|
    add unit_path(unit), lastmod: unit.updated_at
  end

  add contribute_buildings_path
  add new_contact_path
  add about_path


  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  #SitemapGenerator::Sitemap.search_engines
end
