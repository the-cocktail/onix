# coding: utf-8

module ONIX
  class SupplyDetail
    include ROXML

    xml_name "SupplyDetail"

    xml_accessor :supplier, :from => "Supplier", :as => ONIX::Supplier
    xml_accessor :product_availability, :from => "ProductAvailability", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit 
    xml_accessor :prices, :from => "Price", :as => [ONIX::Price]

    def price_amount
			price.total_price_amount if price    	
    end

    def current_price(country)
      # Es obligatorio que o sea para el país o que no especifique país.
      # Ordenados por prioridad:
      # Fecha inicio, fecha fin, fecha valida, precio con iva.
      prices.select{|p| p.valid_for?(country) && p.has_range_dates? && p.valid_date? && p.tax_included? }.first || 
      # Fecha inicio, fecha fin, fecha valida, precio sin iva
      prices.select{|p| p.valid_for?(country) && p.has_range_dates? && p.valid_date? && p.tax_excluded? }.first ||
      # Fecha inicio, fecha valida, precio con iva 
      prices.select{|p| p.valid_for?(country) && p.has_start_date? && p.valid_date? && p.tax_included? }.first ||  
      # Fecha inicio, fecha valida, precio sin iva
      prices.select{|p| p.valid_for?(country) && p.has_start_date? && p.valid_date? && p.tax_excluded? }.first ||  
      # Sin fecha, precio con iva
      prices.select{|p| p.valid_for?(country) && p.tax_included? && !p.has_dates? }.first ||
      # Sin fecha, precio sin iva
      prices.select{|p| p.valid_for?(country) && p.tax_excluded? && !p.has_dates? }.first
    end

    def valid_prices
      prices.map(&:info_hash).compact
    end

  end
end
