module Medusa
  class VoyagerMods < ActiveFedora::NokogiriDatastream

    set_terminology do |t|
      t.root(:path => "mods", :xmlns=>"http://www.loc.gov/mods/v3",
          :schema=>"http://www.loc.gov/standards/mods/v3/mods-3-4.xsd") {
      }
    end

    def self.xml_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.mods {
        }
      end
      return builder.doc
    end

  end
end

