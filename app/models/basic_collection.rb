require 'medusa'
require 'hydra'

class BasicCollection < ActiveFedora::Base

  has_relationship "has_collection_member", :has_collection_member, :inbound => true, :type => ActiveFedora::Base

  # Uses the Hydra Rights Metadata Schema for tracking access permissions & copyright
  has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata

  has_metadata :name => 'descMetadata', :type => Hydra::ModsImage

  has_metadata :name => 'preservationMetadata', :type => Medusa::Premis

  # A place to put extra metadata values
  has_metadata :name => "properties", :type => ActiveFedora::MetadataDatastream do |m|
    #m.field 'description', :string
  end
end