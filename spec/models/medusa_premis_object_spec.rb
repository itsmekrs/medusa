require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "active_fedora"
require "nokogiri"

describe Medusa::PremisObject do

  before(:each) do
    Fedora::Repository.stubs(:instance).returns(stub_everything())
    @object_ds = Medusa::PremisObject.new
  end

  describe ".new" do
    it "should initialize a new premis article template if no xml is provided" do
      object_ds = Medusa::PremisObject.new
      object_ds.ng_xml.to_xml.should == Medusa::PremisObject.xml_template.to_xml
    end
  end
end