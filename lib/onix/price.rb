# coding: utf-8

module ONIX
  class Price
    include ROXML

    xml_name "Price"

    xml_accessor :price_type, :from => "PriceType", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :price_per, :from => "PricePer", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :price_amount, :from => "PriceAmount", :as => BigDecimal, :to_xml => ONIX::Formatters.decimal
    xml_accessor :tax, :from => "Tax", :as => ONIX::Tax 
    xml_accessor :currency_code, :from => "CurrencyCode"
    xml_accessor :territory, :from => "Territory", :as => Territory


  end
end
