# coding: utf-8

module ONIX
  class ImprintIdentifier
    include ROXML

    xml_name "ImprintIdentifier"

    xml_accessor :imprint_id_type,  :from => "ImprintIDType"
    xml_accessor :id_value,         :from => "IDValue"

  end
end
