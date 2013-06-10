# coding: utf-8

module ONIX
  class SupportingResource
    include ROXML

    xml_name "SupportingResource"

    xml_accessor :resource_content_type, :from => "ResourceContentType"
    xml_accessor :content_audience, :from => "ContentAudience"
    xml_accessor :resource_mode, :from => "ResourceMode"
    xml_accessor :resource_version, :from => "ResourceVersion", :as => ONIX::ResourceVersion

  end
end
