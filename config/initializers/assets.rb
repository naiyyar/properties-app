# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

Rails.application.config.assets.precompile += %w(home-main.css search-view.css)
Rails.application.config.assets.precompile += %w(building/main.css building/main.scss building/show.scss reviews.css)
Rails.application.config.assets.precompile += %w(*.js)
