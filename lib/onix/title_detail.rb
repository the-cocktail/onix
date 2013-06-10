# coding: utf-8

module ONIX
  class TitleDetail
    include ROXML

    xml_name "TitleDetail"

    xml_accessor :title_type, :from => "TitleType"
    xml_accessor :title_element, :from => "TitleElement", :as => ONIX::TitleElement
    



  end
end
