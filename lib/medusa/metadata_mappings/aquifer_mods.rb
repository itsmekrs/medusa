require 'lib/medusa/metadata_mappings/xsd_validate'
module Medusa
  class AquiferMods < ActiveFedora::NokogiriDatastream
    include Medusa::XsdValidatingNokogiriDatastream

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
      t.type_of_resource(:path => 'typeOfResource')
      t.language do
        t.language_term(:path => 'languageTerm') do
          t.type_(:path => {:attribute => 'type'})
          t.authority(:path => {:attribute => 'authority'})
        end
      end
      t.physical_description(:path => 'physicalDescription') do
        t.digital_origin(:path => 'digitalOrigin')
        t.internet_media_type(:path => 'internetMediaType')
      end
      t.subject do
        t.authority(:path => {:attribute => 'authority'})
        t.topic
      end
      t.record_info(:path => 'recordInfo') do
        t.language_of_cataloging(:path => 'languageOfCataloging') do
          t.language_term(:path => 'languageTerm') do
            t.authority(:path => {:attribute => 'authority'})
          end
        end
      end
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
          xml.typeOfResource
          xml.language do
            xml.languageTerm(:type => 'code', :authority => 'iso639-2b')
          end
          xml.physicalDescription do
            xml.digitalOrigin('born digital')
            xml.internetMediaType
          end
          xml.subject(:authority => '') do
            xml.topic
          end
          xml.recordInfo do
            xml.languageOfCataloging do
              xml.languageTerm('eng', :authority => 'iso639-2b')
            end
          end
        end
      end
      builder.doc
    end

    def self.xsd_schema_string
      File.new(File.join(File.dirname(__FILE__), 'schemas', 'mods-3-4.xsd')).read
    end

  end
end