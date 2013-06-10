# coding: utf-8

module ONIX
  class CollectionIdentifier
    include ROXML

    xml_name "CollectionIdentifier"

    xml_accessor :collection_id_type, :from => "CollectionIDType"
    xml_accessor :id_value, :from => "IDValue", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit



  end
end
