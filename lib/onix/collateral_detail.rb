# coding: utf-8

module ONIX
  class CollateralDetail
    include ROXML

    xml_name "CollateralDetail"

    xml_accessor :text_contents, :from => "TextContent", :as => [ONIX::TextContent]
    xml_accessor :supporting_resource, :from => "SupportingResource", :as => ONIX::SupportingResource

    def initialize
      self.text_contents = []

    end

  end
end
