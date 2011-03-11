#require 'lib/medusa/metadata_mappings/xsd_validate'

module Medusa
  class PremisObject < ActiveFedora::NokogiriDatastream
    #include Medusa::XsdValidatingNokogiriDatastream

    set_terminology do |t|
      t.root(:path => "premis", :xmlns => "http://www.loc.gov/standards/premis/v1",
             :schema => "http://www.loc.gov/standards/premis/v1 http://www.loc.gov/standards/premis/v1/Object-v1-1.xsd",
             "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance")
      t.object(:attributes => {"xsi:type" => ""}) {
        t.object_identifier(:path => "objectIdentifier") {
          t.object_identifier_type(:path => "objectIdentifierType")
          t.object_identifier_value(:path => "objectIdentifierValue")
        }
        t.object_category(:path => "objectCategory")
        t.object_characteristics(:path => "objectCharacteristics") {
          t.fixity {
            t.message_digest_algorithm(:path => "messageDigestAlgorithm")
            t.message_digest(:path => "messageDigest")
          }
          t.size
          t._format {
            t.format_designation(:path => "formatDesignation") {
              t.format_name(:path => "formatName")
              t.format_version(:path => "formatVersion")
            }
          }
        }
      }
    end

    # Generates an empty PREMIS Object (used when you call PremisObject.new without passing in existing xml)
    def self.xml_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.premisObject("xmlns" => "http://www.loc.gov/standards/premis/v1",
                         "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
                         "xsi:schemaLocation" => "http://www.loc.gov/standards/premis/v1 http://www.loc.gov/standards/premis/v1/Object-v1-1.xsd",
                         :version => "2.1") {
          xml.object("xsi:type" => "file") {
            xml.objectIdentifier {
              xml.objectIdentifierType
              xml.objectIdentifierValue
            }
            xml.objectCategory
            xml.objectCharacteristics {
              xml.fixity {
                xml.messageDigestAlgorithm
                xml.messageDigest
              }
              xml.size
              xml.format {
                xml.formatDesignation {
                  xml.formatName
                  xml.formatVersion
                }
              }
            }
          }
        }
      end
      return builder.doc
    end

    def self.xsd_schema_string
      File.new(File.join(File.dirname(__FILE__), 'schemas', 'Object-v1-1.xsd')).read
    end

  end
end

