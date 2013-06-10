# coding: utf-8

module ONIX
  class SupplyDetail
    include ROXML

    xml_name "SupplyDetail"

    xml_accessor :supplier, :from => "Supplier", :as => ONIX::Supplier
    xml_accessor :product_availability, :from => "ProductAvailability", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit 
    xml_accessor :price, :from => "Price", :as => ONIX::Price

  end
end
