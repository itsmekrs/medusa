require 'hydra'
require 'medusa'
require 'medusa/metadata_mappings/contentdm_record'
require 'medusa/metadata_mappings/voyager_mods'

class PreservationImage < ActiveFedora::Base
  include Hydra::ModelMethods

  # Uses the Hydra Rights Metadata Schema for tracking access permissions & copyright
  has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata

  has_metadata :name => "descMetadata", :type => Hydra::ModsImage

  has_metadata :name => "sourceMetadata", :type => Medusa::ContentdmRecord

  has_metadata :name => "sourceMetadata", :type => Medusa::VoyagerMods

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

