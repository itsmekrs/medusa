#require 'lib/medusa/metadata_mappings/xsd_validate'

module Medusa
  class Premis < ActiveFedora::NokogiriDatastream
    #include Medusa::XsdValidatingNokogiriDatastream

    set_terminology do |t|
      t.root(:path => "object", :xmlns => "http://www.loc.gov/standards/premis/v1",
             :schema => "http://www.loc.gov/standards/premis/v1 http://www.loc.gov/standards/premis/v1/PREMIS-v1-1.xsd",
             "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance")

    end

    # Generates an empty PREMIS Object (used when you call PremisObject.new without passing in existing xml)
    def self.xml_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.premis("xmlns" => "http://www.loc.gov/standards/premis/v1",
                         "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
                         "xsi:schemaLocation" => "http://www.loc.gov/standards/premis/v1 http://www.loc.gov/standards/premis/v1/PREMIS-v1-1.xsd",
                         :version => "2.1") {

        }
      end
      return builder.doc
    end

    def self.xsd_schema_string
      File.new(File.join(File.dirname(__FILE__), 'schemas', 'PREMIS-v1-1.xsd')).read
    end

  end
end