# coding: utf-8

module ONIX
  class CollateralDetail
    include ROXML

    xml_name "CollateralDetail"

    xml_accessor :text_contents, :from => "TextContent", :as => [ONIX::TextContent]
    xml_accessor :supporting_resources, :from => "SupportingResource", :as => [ONIX::SupportingResource]

    def initialize
      self.text_contents = []
    end

    # Text Contents
    ######################

    def find_text_by_text_type(id)
      text_contents.detect{|text| text.text_type == id}
    end

    { 1 => :main_description,
      2 => :short_description,
      3 => :long_description,
      10 => :previous_review_quote
    }.each do |identifier, method_name|
      send :define_method, method_name do
        desc = find_text_by_text_type(identifier)
        desc.text if desc        
      end
    end

    # Supporting Resources
    #####################

    def find_resources_by_content_type(id)
      supporting_resources.select{|resource| resource.resource_content_type == id}
    end

    # => SupportingResource
    ONIX::SupportingResource.resource_content_types.each do |identifier, method_name|
      send :define_method, method_name do
        find_resources_by_content_type(identifier)
      end
    end

    def find_resources_by_resource_mode(id)
      supporting_resources.select{|resource| resource.resource_mode == id}
    end

    # => SupportingResource
    ONIX::SupportingResource.resource_modes.each do |identifier, method_name|
      send :define_method, method_name do
        find_resources_by_resource_mode(identifier)
      end
    end

  end
end
