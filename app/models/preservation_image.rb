require 'hydra'

class PreservationImage < ActiveFedora::Base
  include Hydra::GenericImage
  include Hydra::ModelMethods

  # Uses the Hydra Rights Metadata Schema for tracking access permissions & copyright
  has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata

  has_metadata :name => "descMetadata", :type => Hydra::ModsImage

  # Uses the Medusa PREMIS Object Schema for recording techMD
  has_metadata :name => "technicalMetadata", :type => Medusa::PremisObject

  #has_metadata :name => "provenanceMetadata", :type => Medusa::PremisEvent

  # A place to put extra metadata values
  has_metadata :name => "properties", :type => ActiveFedora::MetadataDatastream do |m|
    m.field 'collection', :string
    m.field 'depositor', :string
    m.field 'title', :string
  end

  def initialize( attrs={} )
    super
  end

end

