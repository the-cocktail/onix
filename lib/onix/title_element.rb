# coding: utf-8

module ONIX
  class TitleElement
    include ROXML

    xml_name "TitleElement"

    xml_accessor :title_element_level, :from => "TitleElementLevel"
    xml_accessor :title_text, :from => "TitleText"
    xml_accessor :subtitle, :from => "Subtitle"


  end
end
