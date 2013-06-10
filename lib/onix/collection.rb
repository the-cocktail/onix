# coding: utf-8

module ONIX
  class Collection
    include ROXML

    xml_name "Collection"

    xml_accessor :collection_type, :from => "CollectionType", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :collection_identifier, :from => "CollectionIdentifier", :as => ONIX::CollectionIdentifier
    xml_accessor :title_detail, :from => "TitleDetail", :as => ONIX::TitleDetail



  end
end
