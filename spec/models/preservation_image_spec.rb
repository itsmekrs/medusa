require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "active_fedora"

describe PreservationImage do

  before(:each) do
    Fedora::Repository.stubs(:instance).returns(stub_everything())
    @preservation_image = PreservationImage.new

  end

  it "Should be a kind of ActiveFedora::Base" do
    @preservation_image.should be_kind_of(ActiveFedora::Base)
  end

  it "should include Hydra Model Methods" do
    @preservation_image.class.included_modules.should include(Hydra::ModelMethods)
    @preservation_image.should respond_to(:apply_depositor_metadata)
  end

  it "should have accessors for its default datastreams of content and original" do
    @preservation_image.should respond_to(:has_content?)
    @preservation_image.should respond_to(:content)
    @preservation_image.should respond_to(:content=)
    @preservation_image.should respond_to(:has_original?)
    @preservation_image.should respond_to(:original)
    @preservation_image.should respond_to(:original=)
  end

  it "should have accessors for its default datastreams of max, screen and thumbnail" do
    @preservation_image.should respond_to(:has_max?)
    @preservation_image.should respond_to(:max)
    @preservation_image.should respond_to(:max=)
    @preservation_image.should respond_to(:has_screen?)
    @preservation_image.should respond_to(:screen)
    @preservation_image.should respond_to(:screen=)
    @preservation_image.should respond_to(:has_thumbnail?)
    @preservation_image.should respond_to(:thumbnail)
    @preservation_image.should respond_to(:thumbnail=)
  end

  describe '#content=' do
    it "shoutld create a content datastream when given an image file" do
    end
  end

  describe '#derive_all' do
    it "should create a max, screen and thumbnail file" do
    end
  end
end