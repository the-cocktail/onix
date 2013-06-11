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


    def tax_included?
      [2,4,7,,9,12,14,17,22,24,27,42].include? price_type
    end

    def tax_excluded?
      !tax_included?
    end

    

  end
end
