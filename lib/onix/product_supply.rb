# coding: utf-8

module ONIX
  class ProductSupply
    include ROXML

    xml_name "ProductSupply"

    xml_accessor :markets, :from => "Market", :as => [ONIX::Market]
    xml_accessor :market_publishing_detail, :from => "MarketPublishingDetail", :as => ONIX::MarketPublishingDetail
    xml_accessor :supply_detail, :from => "SupplyDetail", :as => ONIX::SupplyDetail
    

    def active?
      market_publishing_detail and 
      market_publishing_detail.market_publishing_status == 4
    end

    def market_date
      if market_publishing_detail and market_publishing_detail.market_date
        market_publishing_detail.market_date.full_date
      end
    end

    def supplier
      supply_detail.supplier if supply_detail
    end

    def canceled?
      supply_detail and supply_detail.product_availability == 1
    end

    def will_be_available?
      supply_detail and supply_detail.product_availability%10 == 1
    end

    def available?
      supply_detail and supply_detail.product_availability%10 == 2
    end

    def temporarily_unavailable?
      supply_detail and supply_detail.product_availability%10 == 3
    end

    def not_available?
      supply_detail and 
      (supply_detail.product_availability%10 == 4 or
      supply_detail.product_availability%10 == 5) 
    end

    def unknown?
      supply_detail and supply_detail.product_availability%10 == 9
    end

    def price_amount_for(country)
      if supply_detail
        price_for_country = supply_detail.prices.find do |price|
          price.territory.valid_for?('ES')
        end

        price_for_country ||= supply_detail.prices.first
        price_for_country.price_amount if price_for_country
      end
    end

    def published?
      market_publishing_detail && market_publishing_detail.published?
    end

  end
end
