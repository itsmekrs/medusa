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

  end

  def check_mapping(path)
      @am.get_values(path).should == ['']
      @am.update_values(path => 'Some text')
      @am.get_values(path).first.should == 'Some text'
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
      @am.update_values([:origin_info, :copyright_date, :key_date] => 'no')
      @am.get_values([:origin_info, :copyright_date, :key_date]).first.should == 'no'
    end

    it "should map access condition" do
      check_mapping([:access_condition])
    end
  end
end