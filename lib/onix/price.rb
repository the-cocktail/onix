# coding: utf-8

module ONIX
  class Price
    include ROXML

    TAX_PERCENT = 1.21

    xml_name "Price"

    xml_accessor :price_type, :from => "PriceType", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :price_per, :from => "PricePer", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :price_amount, :from => "PriceAmount", :as => BigDecimal, :to_xml => ONIX::Formatters.decimal
    xml_accessor :tax, :from => "Tax", :as => ONIX::Tax 
    xml_accessor :currency_code, :from => "CurrencyCode"
    xml_accessor :territory, :from => "Territory", :as => Territory
    xml_accessor :price_dates, :from => "PriceDate", :as => [ONIX::PriceDate]

    def tax_included?
      [2,4,7,9,12,14,17,22,24,27,42].include? price_type
    end

    def tax_excluded?
      !tax_included?
    end

    def total_price_amount
      if excluding_taxes?
        (price_amount*TAX_PERCENT).round(2)
      else
        price_amount.to_f
      end
    end

    def has_dates?
      price_dates.present?
    end
    
    def excluding_taxes?
      [1,3,5,6,8,11,13,15,21,23,25,31,32,41].include?(price_type)
    end

    def valid_for?(country='ES')
      # A veces el territory no viene. A veces sí viene, pero vacío (</Territory>). Otras viene y tiene información 
      # Nos vale cuando no viene, o viene vacío o viene relleno con el país válido. 
      # Además, debe tener un valor de impuestos válido.
      valid_tax? && ( (territory.blank?) || (territory.present? && !territory.has_info?) || territory.valid_for?(country) )
    end

    def valid_tax?
      tax.blank? || tax.tax_rate_percent.blank? || (1+(tax.tax_rate_percent/100)==TAX_PERCENT)
    end

    # Date on which a price becomes effective.
    def has_start_date?
      price_dates.any?(&:start_date?)
    end

    # Date on which a price ceases to be effective. 
    def has_end_date?
      price_dates.any?(&:end_date?)
    end

    # Combines From date and Until date to define a period (both dates are inclusive). Use with for example dateformat 06.
    def has_range_dates?
      (price_dates.any?(&:start_date?) && price_dates.any?(&:end_date?)) ||
      (price_dates.any?(&:range_date?))
    end

    def start_date
      if date = (price_dates.select(&:start_date?).first || price_dates.select(&:range_date?).first)
        date.full_date.first
      else
        # si no viene fecha de inicio para un precio, se pone el día de hoy
        Time.now.beginning_of_day
      end
    end

    def end_date
      # Puede venir especificado por end_date (date_role = 15) o por un rango.
      # El rango puede tener un unico día, lo que significa que es una oferta de un único día.
      # Si viene como end_date, la fecha no es inclusiva. restamos un día para que lo sea y en nuestra bbdd sea coherente.
      if date = (price_dates.select(&:end_date?).first)
        end_date = date.full_date.first
        # si tenemos fecha de inicio igual que fecha de fin, estamos en un tagus today, oferta para un solo día
        if end_date && start_date.to_date == end_date.to_date
          end_date
        elsif end_date
          end_date.prev_day
        end
      elsif date = price_dates.select(&:range_date?).first
        date.full_date.last
      end
    end

    def valid_date?
      (start_date.blank? || start_date.past? || start_date.today?) &&
      (end_date.blank? || end_date.future? || end_date.today?)
    end

    # las fechas siempre son INCLUSIVAS
    def info_hash
      if valid_for?('ES')
        { price: total_price_amount,
          tax_included: tax_included?,
          start_date: start_date,
          end_date: end_date }
      end
    end

  end
end
