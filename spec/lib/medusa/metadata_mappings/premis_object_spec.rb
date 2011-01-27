require File.expand_path(File.dirname(__FILE__) + '../../../../spec_helper')
require 'lib/medusa/metadata_mappings/premis_object'

describe Medusa::PremisObject do

  it {should be_a_kind_of ActiveFedora::NokogiriDatastream}
  
end