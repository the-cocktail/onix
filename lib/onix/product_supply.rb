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

    # Sera preventa cuando el product_availability sea diferente a 10 y 11
    def availability_allow_presale?
      [10,11].include?(supply_detail.product_availability)
    end

    def presale_date
      market_publishing_detail.presale_date if market_publishing_detail
    end

    def market_date
      market_publishing_detail.market_date if market_publishing_detail
    end

    def unknown?
      supply_detail and supply_detail.product_availability%10 == 9
    end

    def price_amount_for(country)
      if supply_detail
        price_for_country = supply_detail.prices.find do |price|
          price.territory and price.territory.valid_for?(country)
        end

        price_for_country ||= supply_detail.prices.first
        price_for_country.total_price_amount if price_for_country
      end
    end

    def current_price(country)
      supply_detail.current_price(country) if supply_detail
    end

    def valid_prices(country='ES')
      supply_detail.valid_prices if supply_detail
    end

    def excluding_taxes?(country)
      if supply_detail
        price_for_country = supply_detail.prices.find do |price|
          price.territory and price.territory.valid_for?(country)
        end

        price_for_country ||= supply_detail.prices.first
        price_for_country.excluding_taxes? if price_for_country
      end     
    end

    def published?
      market_publishing_detail && market_publishing_detail.published?
    end

  end
end
