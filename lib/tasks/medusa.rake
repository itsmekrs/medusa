require 'medusa'

desc "Ingest collection"
task :ingest => :environment do
  package_dir = ENV['INGEST_SOURCE_DIR']
  raise "Define environment variable INGEST_SOURCE_DIR" unless package_dir
  Medusa::Ingester.new(package_dir).ingest
end