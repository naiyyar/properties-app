namespace :sitemap do
  desc 'Upload the sitemap files to S3'
  task upload_to_s3: :environment do
    s3 = Aws::S3::Resource.new(region: 'us-west-2')
    bucket = ENV['AWS_S3_BUCKET']
    Dir.entries(File.join(Rails.root, "public", "sitemaps")).each do |file_name|
      next if ['.', '..'].include? file_name
      path = "sitemaps/#{file_name}"
      file = File.join(Rails.root, "public", "sitemaps", file_name)
 
      begin
        obj = s3.bucket(bucket).object(path)
        obj.upload_file(file, acl: 'public-read')
      rescue Exception => e
        raise e
      end
      puts "Saved #{file_name} to S3"
    end
  end

  desc 'Create the sitemap, then upload it to S3 and ping the search engines'
  task create_upload_and_ping: :environment do
    Rake::Task["sitemap:refresh"].invoke

    Rake::Task["sitemap:upload_to_s3"].invoke

    SitemapGenerator::Sitemap.ping_search_engines
  end
end


desc 'Upload the error messages files to S3'
task upload_custom_error_message_files_to_s3: :environment do
  s3 = Aws::S3::Resource.new(region: 'us-west-2')
  bucket = ENV['AWS_S3_BUCKET']
  Dir.entries(File.join(Rails.root, "public", "custom_errors")).each do |file_name|
    next if ['.', '..'].include? file_name
    path = "custom_errors/#{file_name}"
    file = File.join(Rails.root, "public", "custom_errors", file_name)

    begin
      obj = s3.bucket(bucket).object(path)
      obj.upload_file(file, acl: 'public-read')
    rescue Exception => e
      raise e
    end
    puts "Saved #{file_name} to S3"
  end
end