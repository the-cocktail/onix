# coding: utf-8

module ONIX
  class MarketPublishingDetail
    include ROXML

    xml_name "MarketPublishingDetail"
    
    xml_accessor :market_publishing_status, :from => "MarketPublishingStatus"
    xml_accessor :market_date, :from => "MarketDate", :as => ONIX::MarketDate


  end
end
