# coding: utf-8

module ONIX
  class ImprintIdentifier
    include ROXML

    xml_name "ImprintIdentifier"

    xml_accessor :imprint_id_type,  :from => "ImprintIDType", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :id_value,         :from => "IDValue"

  end
end
