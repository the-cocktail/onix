# coding: utf-8

module ONIX
  class Collection
    include ROXML

    xml_name "Collection"

    xml_accessor :collection_type, :from => "CollectionType", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :collection_identifier, :from => "CollectionIdentifier", :as => ONIX::CollectionIdentifier
    xml_accessor :title_details, :from => "TitleDetail", :as => [ONIX::TitleDetail]

    def series?
      collection_type and collection_type != 0
    end

    def issn
      if collection_identifier && collection_identifier.collection_id_type == 2
        collection_identifier.id_value
      end
    end

    def series_id
      collection_identifier.id_value if collection_identifier
    end

    def main_title_detail
      title_details.find{|td| td.title_type == 1}
    end

    def title
      main_title_detail.collection_title if main_title_detail
    end

    def subcollection_title
      main_title_detail.subcollection_title if main_title_detail
    end

  end
end
