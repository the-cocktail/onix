# coding: utf-8

module ONIX
  class CollectionIdentifier
    include ROXML

    xml_name "CollectionIdentifier"

    xml_accessor :collection_id_type, :from => "CollectionIDType", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :id_value



  end
end
