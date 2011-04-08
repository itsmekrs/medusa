module ContentDm
  module AfricanMaps
    class Collection < ActiveFedora::Base
      has_relationship "items", :is_member_of, :inbound => :true
      has_metadata :name => 'mods', :type => ActiveFedora::MetadataDatastream
      has_metadata :name => 'premis', :type => ActiveFedora::MetadataDatastream
    end
  end
end