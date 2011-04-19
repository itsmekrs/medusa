#require 'lib/medusa/metadata_mappings/xsd_validate'

module Medusa
  class Premis < ActiveFedora::NokogiriDatastream
    #include Medusa::XsdValidatingNokogiriDatastream

    set_terminology do |t|
      t.root(:path       => "premis", :xmlns => "info:lc/xmlns/premis-v2",
             :schema     => "info:lc/xmlns/premis-v2 http://www.loc.gov/standards/premis/v2/premis-v2-1.xsd",
             :version    => "2.1",
             "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance")
      t.representation_object(:attributes=>{:type=>"representation"}) {
        t.relationship {
          t.relationshipType
          t.relationshipSubType
          t.relatedObjectIdentification {
            t.relatedObjectIdentifierType
            t.relatedObjectIdentifierValue
          }
        }
      }

    end

    # Generates an empty PREMIS Object (used when you call PremisObject.new without passing in existing xml)
    def self.xml_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.premis("xmlns"              => "info:lc/xmlns/premis-v2",
                   "xmlns:xsi"          => "http://www.w3.org/2001/XMLSchema-instance",
                   "xsi:schemaLocation" => "info:lc/xmlns/premis-v2 http://www.loc.gov/standards/premis/v2/premis-v2-1.xsd",
                   :version             => "2.1") {

        }
      end
      return builder.doc
    end

    def root_metadata_filename
      xpath   = "/oxns:premis/oxns:object/oxns:relationship[oxns:relationshipType='METADATA'][oxns:relationshipSubType='HAS_ROOT']/oxns:relatedObjectIdentification[oxns:relatedObjectIdentifierType='FILENAME']/oxns:relatedObjectIdentifierValue"
      nodeset = self.find_by_terms(xpath)
      if nodeset.empty?
        return "none"
      else
        return nodeset.first.text
      end
    end

    def self.xsd_schema_string
      File.new(File.join(File.dirname(__FILE__), 'schemas', 'PREMIS-v1-1.xsd')).read
    end

  end
end