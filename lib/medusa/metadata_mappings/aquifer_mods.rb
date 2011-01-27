module Medusa
  class AquiferMods < ActiveFedora::NokogiriDatastream
    set_terminology do |t|
      t.root(:path => "mods", :xmlns=>"http://www.loc.gov/mods/v3",
          :schema=>"http://www.loc.gov/standards/mods/v3/mods-3-4.xsd")
      t.name_ do
        t.name_part(:path => 'namePart')
      end
      t.title_info(:path => 'titleInfo') do
        t.title
      end
      t.origin_info(:path => 'originInfo') do
        t.copyright_date(:path => 'copyrightDate') do
          t.key_date(:path => {:attribute => 'keyDate'})
        end
      end
      t.location do
        t.url
      end
      t.access_condition(:path => 'accessCondition')
    end

    def self.xml_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.mods(:xmlns => "http://www.loc.gov/mods/v3") do
          xml.name do
            xml.namePart
          end
          xml.titleInfo do
            xml.title
          end
          xml.originInfo do
            xml.copyrightDate(:keyDate => 'yes')
          end
          xml.location do
            xml.url
          end
          xml.accessCondition
        end
      end
      builder.doc
    end

    def self.xsd_schema
      File.new(File.join(File.dirname(__FILE__), 'schemas', 'mods-3-4.xsd')).read
    end

    def self.schema
      Nokogiri::XML::Schema.new(self.xsd_schema)
    end

    def valid?
      self.class.schema.valid?(self.ng_xml)
    end

    def validate
      self.class.schema.validate(self.ng_xml)
    end
  end
end