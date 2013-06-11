# coding: utf-8

module ONIX
  class Collection
    include ROXML

    xml_name "Collection"

    xml_accessor :collection_type, :from => "CollectionType", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :collection_identifier, :from => "CollectionIdentifier", :as => ONIX::CollectionIdentifier
    xml_accessor :title_detail, :from => "TitleDetail", :as => ONIX::TitleDetail

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

		# TODO title_type indica si es el titulo de la serie 
		# u otras muchas cosas (titulo traducido, abreviado ,alternativo, etc)
		# quiza hay que poner title details como un array en caso de que nos pases
		# mas de uno 
    def title
    	title_detail.title if title_detail
    end

  end
end
