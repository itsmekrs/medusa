#require 'lib/medusa/metadata_mappings/xsd_validate'

module Medusa
  class PremisEvent < ActiveFedora::NokogiriDatastream
    #include Medusa::XsdValidatingNokogiriDatastream

    set_terminology do |t|
      t.root(:path => "premis", :xmlns => "http://www.loc.gov/standards/premis/v1",
             :schema => "http://www.loc.gov/standards/premis/v1 http://www.loc.gov/standards/premis/v1/Event-v1-1.xsd",
             "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance")
      t.event(:attributes => {"xsi:type" => ""}) {
      }
    end

    # Generates an empty PREMIS Event (used when you call PremisEvent.new without passing in existing xml)
    def self.xml_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.premisEvent("xmlns" => "http://www.loc.gov/standards/premis/v1",
                         "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
                         "xsi:schemaLocation" => "http://www.loc.gov/standards/premis/v1 http://www.loc.gov/standards/premis/v1/Event-v1-1.xsd",
                         :version => "2.1") {
          xml.event {
          }
        }
      end
      return builder.doc
    end

    def self.xsd_schema_string
      File.new(File.join(File.dirname(__FILE__), 'schemas', 'Event-v1-1.xsd')).read
    end

  end
end

