# coding: utf-8

module ONIX
  class ProductSupply
    include ROXML

    xml_name "ProductSupply"

    xml_accessor :markets, :from => "Market", :as => [ONIX::Market]
    xml_accessor :market_publishing_detail, :from => "MarketPublishingDetail", :as => ONIX::MarketPublishingDetail
    xml_accessor :supply_detail, :from => "SupplyDetail", :as => ONIX::SupplyDetail
    
  end
end
