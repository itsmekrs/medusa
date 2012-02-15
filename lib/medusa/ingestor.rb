require 'om'
require 'lib/medusa/generic_ingestor'

class Medusa::Ingester < Medusa::GenericIngestor

  def ingest
    puts "Ingesting from #{package_root}"
    #Read collection information and create collection object via AF
    #collection includes premis and mods metadata and a collection_description.txt
    #Need to read the premis to get the id for the collection object
    collection = create_collection('collection')

    #For each item read item information and create item object via AF
    Dir.entries(package_root).each do |top_level_dir|
      # we want all the directories except collection
      top_level_path = File.join package_root, top_level_dir
      next unless File.directory? top_level_path
      next if top_level_dir == '.' or top_level_dir == '..' or top_level_dir == 'collection'

      Dir.entries(top_level_path).each do |item_dir|
        next if item_dir == '.' or item_dir == '..'
        item_local_path = File.join top_level_dir, item_dir
        begin
          self.create_item(item_local_path)
        rescue Exception => e
          puts "[ERROR]: cannot ingest package from #{item_local_path}: #{e.message}"
        end
      end

    end

    #Output collection/item PIDS etc. for reference
    puts collection.pid
  end

  # Creates a new collection in Fedora
  #
  # @param [String] collection_path the LOCAL path of the collection directory  from package_root
  # @return [Medusa::BasicCollection] the collection object
  def create_collection(collection_path)
    premis_xml = package_file_xml(collection_path, 'premis.xml')
    handle = get_handle(premis_xml)
    pid = handle_to_pid(handle)
    replacing_object(pid) do
      #create collection, attach streams, return collection
      collection = Medusa::BasicCollection.new(:pid => pid)
      collection.datastreams['preservationMetadata'].ng_xml = premis_xml
      #open the premis and get the mods filename
      root_metadata_filename = collection.datastreams['preservationMetadata'].root_metadata_file
      mods_xml = package_file_xml('collection', root_metadata_filename)
      collection.datastreams['descMetadata'].ng_xml = mods_xml
      title = collection.datastreams['descMetadata'].term_values(:title_info)
      collection.label = title
      #look in the premis file for rights data


      collection.save
      collection
    end
  end

  # Creates a new item in Fedora
  #
  # @param [String] item_path the LOCAL path of the item directory  from package_root
  # @return [Medusa::BasicImage] the item object
  def create_item(item_path)

    premis_xml = package_file_xml(item_path, 'premis.xml')
    handle = get_handle(premis_xml)
    pid = handle_to_pid(handle)
    replacing_object(pid) do
      #create collection, attach streams, return collection
      item = Medusa::BasicImage.new(:pid => pid)
      premis_ds = item.datastreams['preservationMetadata']
      premis_ds.ng_xml = premis_xml
      premis_ds.label = "PREMIS"
      #open the premis and get the mods filename
      root_metadata_filename = premis_ds.root_metadata_file
      mods_xml = package_file_xml(item_path, root_metadata_filename)
      mods_ds = item.datastreams['descMetadata']
      mods_ds.ng_xml = mods_xml
      mods_ds.label = "MODS"
      title = mods_ds.term_values(:title_info)
      item.label = title
      #derivation files
      premis_ds.derivation_source_file_array.each_with_index do |deriv_file, i|
        ds_id = "DERIVATION#{i}"
        ds_path = package_file(item_path, deriv_file)
        deriv_ds = ActiveFedora::Datastream.new(:dsId => ds_id, :dsLabel => deriv_file, :controlGroup => "M", :blob => File.open(ds_path))
        item.add_datastream deriv_ds
      end

      #rigths metadata

      #content
      pm_filename = item.datastreams['preservationMetadata'].production_master_file
      pm_path = package_file(item_path, pm_filename)
      pm_ds = ActiveFedora::Datastream.new(:dsId => "PRODUCTION_MASTER", :dsLabel => pm_filename, :controlGroup => "M", :blob => File.open(pm_path))
      item.add_datastream pm_ds

      item.save
      item
    end
  end

  protected

  def package_file(*args)
    File.join(package_root, *args)
  end

  def package_file_contents(*args)
    File.read(package_file(*args))
  end

  def package_file_xml(*args)
    Nokogiri::XML::Document.parse(package_file_contents(*args))
  end

  def get_handle(premis_xml)
    ids = premis_xml.css("premis > object > objectIdentifier")
    id = ids.detect { |id| id.css('objectIdentifierType').text == 'HANDLE' }
    id.css('objectIdentifierValue').text
  end

  def handle_to_pid(handle)
    handle.gsub(/^(.*?)\//, '')
  end

end