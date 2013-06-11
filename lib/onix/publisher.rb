# coding: utf-8

module ONIX
  class Publisher
    include ROXML

    xml_name "Publisher"

    xml_accessor :publishing_role,      :from => "PublishingRole", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :name_code_type,       :from => "NameCodeType", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :name_code_type_name,  :from => "NameCodeTypeName"
    xml_accessor :name_code_type_value, :from => "NameCodeTypeValue"
    xml_accessor :publisher_name,       :from => "PublisherName"
    xml_accessor :website,              :from => "Website", :as => ONIX::Website

    def link
      website.website_link if website
    end

  end
end
