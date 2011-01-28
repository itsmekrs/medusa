require File.expand_path(File.dirname(__FILE__) + '../../../../spec_helper')
require 'lib/medusa/metadata_mappings/premis_object'

describe Medusa::PremisObject do

  it {should be_a_kind_of ActiveFedora::NokogiriDatastream}

  describe "creating a new record" do
    before(:each) do
      @po = Medusa::PremisObject.new
    end

    it "should be a valid Premis Object" do
      pending
      #@po.valid?.should be_true
    end
    
  end
end