require 'lib/medusa/african_maps/premis_collection_parser'
require 'lib/medusa/african_maps/premis_item_parser'
require 'lib/medusa/generic_ingestor'
require 'active_fedora'

module Medusa
  module AfricanMaps
    class Ingestor < Medusa::GenericIngestor

      def ingest
        #ingest collection
        #create collection object
        #attach metadata streams
        collection = PremisCollectionParser.new(File.join(self.package_root, 'collection', 'premis.xml')).parse
        puts "INGESTING COLLECTION: #{collection.medusa_id}"
        fedora_collection = nil
        replacing_object(collection.medusa_id) do
          fedora_collection = ActiveFedora::Base.new(:pid => collection.medusa_id)
          premis_ds = ActiveFedora::Datastream.new(:dsId => 'PREMIS', :dsLabel => 'PREMIS',
                                                   :controlGroup => "X",
                                                   :blob => File.open(collection.premis_file))
          fedora_collection.add_datastream(premis_ds)
          fedora_collection.save
        end
        puts "INGESTED COLLECTION: #{collection.medusa_id}"

        #ingest each item in collection
        ## create item object
        ## attach to collection
        ## attach metadata streams
        ## create image object
        ## attach to item
        ## attach image stream - no separate metadata
        Dir[File.join(self.package_root, '*', '*', 'premis.xml')].each do |item_file|
          #item = PremisItemParser.new(item_file).parse
          #puts "ITEM:"
          #puts "\tID: #{item.medusa_id}"
          #puts "\tCOLLECTION_ID: #{item.collection_id}"
          #puts "\tIMAGE: #{item.image_file}"
          #puts "\tMODS: #{item.mods_file}"
          #puts "\tPREMIS: #{item.premis_file}"
          #puts "\tCON_DM: #{item.content_dm_file}"
          #puts "\tMARC: #{item.marc_file}"
          #puts "\tIMAGE: #{item.image_file}"
          #puts ""
        end
      end

    end
  end
end