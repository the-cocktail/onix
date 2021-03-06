# coding: utf-8

module ONIX
  class ResourceVersion
    include ROXML

    xml_name "ResourceVersion"

    xml_accessor :resource_form, :from => "ResourceForm", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :resource_link, :from => "ResourceLink"

  end
end
