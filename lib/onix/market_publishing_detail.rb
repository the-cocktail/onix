# coding: utf-8

module ONIX
  class MarketPublishingDetail
    include ROXML

    xml_name "MarketPublishingDetail"
    
    xml_accessor :market_publishing_status, :from => "MarketPublishingStatus", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :market_date, :from => "MarketDate", :as => ONIX::MarketDate

    def published?
    	market_publishing_status == 4
    end

    def presale_date?
    	market_date and market_date.full_date.future?
    end

    def presale_date
			market_date.full_date if presale_date?     	
    end

  end
end
