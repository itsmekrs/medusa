#Rake tasks related to dealing with the ContentDM/AfricanMaps collection
require 'lib/content_dm/african_maps/ingester'

namespace :content_dm do
  namespace :african_maps do
    desc "Ingest collection"
    task :ingest => :environment do
      package_dir = ENV['INGEST_SOURCE_DIR']
      raise "Define environment variable INGEST_SOURCE_DIR" unless package_dir
      ContentDm::AfricanMaps::Ingester.new(package_dir).ingest
    end
  end
end
