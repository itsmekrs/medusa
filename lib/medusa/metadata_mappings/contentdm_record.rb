module Medusa
  class ContentDmRecord < ActiveFedora::NokogiriDatastream

    set_terminology do |t|
      t.root(:path => "record") {
      }
    end

    def self.xml_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.record {
        }
      end
      return builder.doc
    end

  end
end

