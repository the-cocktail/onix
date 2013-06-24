# coding: utf-8

module ONIX
  class Territory
    include ROXML

    xml_name "Territory"

    xml_accessor :countries_included, :from => "CountriesIncluded" do |val|
      val.present? ? val.split(' ') : []
    end

    xml_accessor :regions_included, :from => "RegionsIncluded" do |val|
      val.present? ? val.split(' ') : []
    end

    def valid_for?(country)
    	countries_included.include?(country) or
    	regions_included.include?(country) or
    	regions_included.include?('WORLD')
    end


  end
end
