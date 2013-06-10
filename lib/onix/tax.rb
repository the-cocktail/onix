# coding: utf-8

module ONIX
  class Tax
    include ROXML

    xml_name "Tax"

    xml_accessor :tax_rate_code, :from => "TaxRateCode"
    xml_accessor :tax_rate_percent, :from => "TaxRatePercent", :as => BigDecimal, :to_xml => ONIX::Formatters.decimal
    xml_accessor :taxable_amount, :from => "TaxableAmount", :as => BigDecimal, :to_xml => ONIX::Formatters.decimal
    xml_accessor :tax_amount, :from => "TaxAmount", :as => BigDecimal, :to_xml => ONIX::Formatters.decimal


  end
end
