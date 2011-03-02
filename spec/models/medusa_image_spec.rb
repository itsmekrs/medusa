require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "active_fedora"

describe MedusaImage do

  before(:each) do
    Fedora::Repository.stubs(:instance).returns(stub_everything())
    @medusa_image = MedusaImage.new

  end

  it "Should be a kind of ActiveFedora::Base" do
    @medusa_image.should be_kind_of(ActiveFedora::Base)
  end

  it "should include Hydra Model Methods" do
    @medusa_image.class.included_modules.should include(Hydra::ModelMethods)
    @medusa_image.should respond_to(:apply_depositor_metadata)
  end
end