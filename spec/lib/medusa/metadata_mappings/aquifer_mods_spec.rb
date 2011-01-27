require File.expand_path(File.dirname(__FILE__) + '../../../../spec_helper')
require 'lib/medusa/metadata_mappings/aquifer_mods'

describe Medusa::AquiferMods do

  it { should be_a_kind_of(ActiveFedora::NokogiriDatastream) }

  describe "creating a new record" do
    before(:each) do
      @am = Medusa::AquiferMods.new
      @am_xml = @am.ng_xml
    end

    it "should be valid MODS" do
      @am.valid?.should be_true
    end

    it "should have a name with name part" do
      @am_xml.css('mods > name > namePart').should_not be_empty
    end

    it "should Have a titleInfo with title" do
      @am_xml.css('mods > titleInfo > title').should_not be_empty
    end

    it "should Have an originInfo with date" do
      @am_xml.css('mods > originInfo > copyrightDate[keyDate]').should_not be_empty
    end

    it "should Have a location with url" do
      @am_xml.css('mods > location > url').should_not be_empty
    end

    it "should Have an accessCondition" do
      @am_xml.css('mods > accessCondition').should_not be_empty
    end

    it "should have a typeOfResource" do
      @am_xml.css('mods > typeOfResource').should_not be_empty
    end

    it "should have a language with languageTerm and attributes" do
      @am_xml.css('mods > language > languageTerm[type]').should_not be_empty
      @am_xml.css('mods > language > languageTerm[authority]').should_not be_empty
    end

    it "should have a physicalDescription element with digitalOrigin and internetMediaType subelements" do
      @am_xml.css('mods > physicalDescription > digitalOrigin').should_not be_empty
      @am_xml.css('mods > physicalDescription > internetMediaType').should_not be_empty
    end

    it "should have a subject element with some attributes and sub elements" do
      @am_xml.css('mods > subject[authority]').should_not be_empty
      @am_xml.css('mods > subject > topic').should_not be_empty
    end

    it "should have a recordInfo element with languageOfCataloging -> languageTerm subelement with authority code" do
      @am_xml.css('mods > recordInfo > languageOfCataloging > languageTerm[authority]').should_not be_empty
    end
  end

  def check_mapping(path, new_value = nil)
    @am.get_values(path).should == ['']
    check_update(path, new_value)
  end

  def check_update(path, new_value = nil)
    new_value ||= 'Some text'
    @am.update_values(path => new_value)
    @am.get_values(path).first.should == new_value
  end

  describe "terminology mapping" do
    before(:each) do
      @am = Medusa::AquiferMods.new
    end

    it "should map name" do
      check_mapping([:name, :name_part])
    end

    it "should map title" do
      check_mapping([:title_info, :title])
    end

    it "should map location" do
      check_mapping([:location, :url])
    end

    it "should map origin info" do
      check_mapping([:origin_info, :copyright_date])
      check_update([:origin_info, :copyright_date, :key_date])
    end

    it "should map access condition" do
      check_mapping([:access_condition])
    end

    it "should map type of resource" do
      check_mapping([:type_of_resource])
    end

    it "should map language, language_term, and attributes" do
      check_mapping([:language, :language_term])
      check_update([:language, :language_term, :type], 'text')
    end

    it "should map physicalDescription with digitalOrigin and internetMediaType" do
      check_update([:physical_description, :digital_origin], 'digitized other analog')
      check_mapping([:physical_description, :internet_media_type])
    end

    it "should map subject with some attributes and sub-elements" do
      check_mapping([:subject, :topic])
      check_mapping([:subject, :authority])
    end

    it "should map recordInfo with subelements" do
      check_update([:record_info, :language_of_cataloging, :language_term], 'eng')
      check_update([:record_info, :language_of_cataloging, :language_term, :authority], 'iso639-2b')
    end
  end
end