# coding: utf-8

module ONIX
  class TitleDetail
    include ROXML

    xml_name "TitleDetail"

    xml_accessor :title_type, :from => "TitleType", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :title_elements, :from => "TitleElement", :as => [ONIX::TitleElement]
    

    { 1 => :main_title_element,
      2 => :collection_title_element,
      3 => :subcollection_title_element
    }.each do |identifier, method_name|
      send :define_method, method_name do
        title_elements.find{|te| te.title_element_level == identifier }
      end
    end

    def title
      main_title_element.title_text if main_title_element
    end

    def subtitle
      main_title_element.subtitle if main_title_element
    end

    def collection_title
      collection_title_element.title_text if collection_title_element
    end

    def subcollection_title
      subcollection_title_element.title_text if subcollection_title_element
    end

  end
end
