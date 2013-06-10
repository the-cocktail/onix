# coding: utf-8

module ONIX
  class Territory
    include ROXML

    xml_name "Territory"

    xml_accessor :countries_included, :from => "CountriesIncluded" do |val|
      val.split(' ')
    end


  end
end
