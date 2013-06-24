# coding: utf-8

module ONIX
  class TitleDetail
    include ROXML

    xml_name "TitleDetail"

    xml_accessor :title_type, :from => "TitleType", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :title_elements, :from => "TitleElement", :as => [ONIX::TitleElement]
    
    def main_title_element
      title_elements.find{|te| te.title_element_level == 1 }
    end

    def collection_title_element
      title_elements.find{|te| te.title_element_level == 2 }
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

  end
end
