#mix this in to get some methods to validate against an xsd schema.
#The class must define a class method xsd_schema_string that
#returns the xsd schema as a string
module Medusa

  module XsdValidatingNokogiriDatastreamClassMethods
    def schema
      Nokogiri::XML::Schema.new(self.xsd_schema_string)
    end

    def xsd_schema_string
      raise RuntimeError, 'Subclass Responsibility'
    end

  end

  module XsdValidatingNokogiriDatastream
    def XsdValidatingNokogiriDatastream.included(klass)
      klass.extend(XsdValidatingNokogiriDatastreamClassMethods)
    end

    def valid?
      self.class.schema.valid?(self.ng_xml)
    end

    def validate
      self.class.schema.validate(self.ng_xml)
    end
  end


end