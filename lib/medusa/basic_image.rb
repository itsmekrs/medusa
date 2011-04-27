module Medusa
  require_dependency 'vendor/plugins/hydra_repository/lib/hydra.rb'

  class BasicImage < ActiveFedora::Base
    include Hydra::GenericImage
    include Hydra::ModelMethods

    # Uses the Hydra Rights Metadata Schema for tracking access permissions & copyright
    has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata

    has_metadata :name => "descMetadata", :type => Hydra::ModsImage

    has_metadata :name => 'preservationMetadata', :type => Medusa::Premis

    # A place to put extra metadata values
    has_metadata :name => "properties", :type => ActiveFedora::MetadataDatastream do |m|
      m.field 'collection', :string
      m.field 'depositor', :string
      m.field 'title', :string
    end

    def initialize(attrs={})
      super(attrs)
      add_relationship(:has_model, "hydra-cModel:commonMetadata")
      add_relationship(:has_model, "hydra-cModel:genericContent")
      add_relationship(:has_model, "hydra-cModel:genericImage")
      #add_relationship(:isMemberOf, Medusa::BasicCollection)
    end
  end
end