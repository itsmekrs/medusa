require 'medusa'

class Medusa::Ingester
  attr_accessor :package_dir

  def initialize(package_dir)
    self.package_dir = package_dir
  end

  def ingest
    puts "Ingesting from #{self.package_dir}"
    #Read collection information and create collection object via AF
    #collection includes premis and mods metadata and a collection_description.txt
    #Need to read the premis to get the id for the collection object
    collection = self.create_collection

    #For each item read item information and create item object via AF


    #Output collection/item PIDS etc. for reference
    puts collection.pid
  end

  def create_collection
    premis_xml = package_file_xml('collection', 'premis.xml')
    mods_xml   = package_file_xml('collection', 'mods.xml')
    handle     = get_handle(premis_xml)
    pid        = handle_to_pid(handle)
    replacing_object(pid) do
      #create collection, attach streams, return collection
      collection                                            = Medusa::BasicCollection.new(:pid => pid)
      collection.datastreams['preservationMetadata'].ng_xml = premis_xml
      collection.datastreams['descMetadata'].ng_xml         = mods_xml
      collection.save
      collection
    end
  end

  protected

  def package_file(*args)
    File.join(package_dir, *args)
  end

  def package_file_contents(*args)
    File.read(package_file(*args))
  end

  def package_file_xml(*args)
    Nokogiri::XML::Document.parse(package_file_contents(*args))
  end

  def get_handle(premis_xml)
    ids = premis_xml.css("premis > object > objectIdentifier")
    id  = ids.detect { |id| id.css('objectIdentifierType').text == 'HANDLE' }
    id.css('objectIdentifierValue').text
  end

  def handle_to_pid(handle)
    handle.gsub(/^(.*?)\//, '')
  end

  #If there is an object with the given pid delete it and yield to the block.
  #For making this repeatable without hassle.
  def replacing_object(pid)
    if object = ActiveFedora::Base.find(pid)
      object.delete
    end
    yield
  end

end