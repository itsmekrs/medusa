require File.expand_path(File.dirname(__FILE__) + '../../../../spec_helper')
require 'lib/medusa/metadata_mappings/premis_event'
require "active_fedora"
require "nokogiri"

describe Medusa::PremisEvent do

  before(:each) do
    Fedora::Repository.stubs(:instance).returns(stub_everything())
    @object_ds = Medusa::PremisEvent.new
  end

  describe ".new" do
    it "should initialize a new premis article template if no xml is provided" do
      object_ds = Medusa::PremisEvent.new
      object_ds.ng_xml.to_xml.should == Medusa::PremisEvent.xml_template.to_xml
    end
  end

  it "should be a valid Premis Event" do
    pending
    #@po.valid?.should be_true
  end

end