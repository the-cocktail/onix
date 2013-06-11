# coding: utf-8

module ONIX
  class TextContent
    include ROXML

    xml_name "TextContent"

    xml_accessor :text_type, :from => "TextType", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :content_audience, :from => "ContentAudience"
    xml_accessor :text, :from => "Text"

  end
end
