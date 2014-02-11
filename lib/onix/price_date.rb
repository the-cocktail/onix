# coding: utf-8

module ONIX
  class PriceDate
    include ROXML

    xml_name "PriceDate"

    xml_accessor :price_date_role, from: 'PriceDateRole', as: Fixnum, to_xml: ONIX::Formatters.two_digit
    xml_accessor :date_format, from: "DateFormat"
    xml_accessor :date, from: "Date"

    def full_date
      case self.date_format
      when '00' then [DateTime.strptime(self.date, '%Y%m%d')]
      when '01' then [DateTime.strptime(self.date, '%Y%m')]
      when '02' then [DateTime.strptime(self.date, '%Y%V')]
      when '04' then [DateTime.strptime(self.date[0..-2], "%Y")]
      when '05' then [DateTime.strptime(self.date, "%Y")]
      when '06' then [DateTime.strptime(self.date.first(8), '%Y%m%d'),DateTime.strptime(self.date.last(8), '%Y%m%d')]
      when '07' then [DateTime.strptime(self.date.first(6), '%Y%m'),  DateTime.strptime(self.date.last(6), '%Y%m')]
      when '08' then [DateTime.strptime(self.date.first(6), '%Y%V'),  DateTime.strptime(self.date.last(6), '%Y%V')]
      when '14' then [DateTime.strptime(self.date.first(8), '%Y%m%d')]
      end        
    end

    def start_date?
      price_date_role == 14
    end

    def end_date?
      price_date_role == 15
    end

    def range_date?
      price_date_role == 24
    end

  end
end