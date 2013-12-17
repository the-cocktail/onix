# coding: utf-8

module ONIX
  class MarketDate
    include ROXML

    xml_name "MarketDate"

    xml_accessor :market_date_role, :from => "MarketDateRole"
    xml_accessor :date_format, :from => "DateFormat"
    xml_accessor :date, :from => "Date"

    def full_date
      case self.date_format
      when '00' then DateTime.strptime(self.date, '%Y%m%d')
      when '01' then DateTime.strptime(self.date, '%Y%m')
      when '02' then DateTime.strptime(self.date, '%Y%V')
      when '04' then DateTime.strptime(self.date[0..-2], "%Y")
      when '05' then DateTime.strptime(self.date, "%Y")
      when '06' then DateTime.strptime(self.date.last(8), '%Y%m%d')
      when '07' then DateTime.strptime(self.date.last(6), '%Y%m')
      when '08' then DateTime.strptime(self.date.last(6), '%Y%V')
      end        
    end


  end
end
