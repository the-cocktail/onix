# coding: utf-8

module ONIX
  class Product
    include ROXML

    xml_name "Product"

    xml_accessor :record_reference, :from => "RecordReference"
    xml_accessor :notification_type, :from => "NotificationType", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :record_source_type, :from => "RecordSourceType", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :product_identifiers, :from => "ProductIdentifier", :as => [ONIX::ProductIdentifier]
    xml_accessor :descriptive_detail, :from => "DescriptiveDetail", :as => ONIX::DescriptiveDetail
    xml_accessor :collateral_detail, :from => "CollateralDetail", :as => ONIX::CollateralDetail
    xml_accessor :publishing_detail, :from => "PublishingDetail", :as => ONIX::PublishingDetail
    xml_accessor :related_material, :from => "RelatedMaterial", :as => ONIX::RelatedMaterial
    xml_accessor :product_supplies, :from => "ProductSupply", :as => [ONIX::ProductSupply]

    def initialize
      self.product_identifiers = []
      self.product_supplies = []
    end

    # NotificationType
    #########################

    def create?
      [1,2,3,8,9,12,13,14].include? notification_type
    end

    def update?
      notification_type == 4
    end

    def delete?
      notification_type == 5
    end

    # ProductIdentifiers
    #########################
    def product_identifier_by_id(id)
      product_identifiers.find{|pi| pi.product_id_type == id}
    end

    { 3  => :id_gtin13,
      15 => :id_isbn13,
      1  => :id_propietary
    }.each do |identifier, method_name|
      send :define_method, method_name do
        prod_id = product_identifier_by_id(identifier)
        prod_id.id_value if prod_id
      end
    end

    # Accesos a cosas más usadas
    ############################

    def main_contributor
      descriptive_detail.main_contributor if descriptive_detail
    end

    def main_contributors
      descriptive_detail.main_contributors if descriptive_detail
    end

    def collection
      descriptive_detail.collection if descriptive_detail
    end

    [:title, :title_vo, :subtitle, :collection_title, :subcollection_title].each do |name|
      send :define_method, name do
        descriptive_detail.try(name) if descriptive_detail
      end
    end

    def merge_collection_titles
      # A veces viene desde Collection y otras veces
      # desde DescriptiveDetail. Aqui probamos con ambas
      if collection and collection.title.present?
        collection.title
      else
        collection_title
      end
    end

    def merge_subcollection_titles
      # Ocurre lo mismo que con el titulo de la coleccion
      if collection and collection.subcollection_title.present?
        collection.subcollection_title
      else
        subcollection_title
      end
    end

    def language_code
      if descriptive_detail and descriptive_detail.main_language
        descriptive_detail.main_language.language_code
      end
    end

    def original_language_code
      if descriptive_detail and descriptive_detail.original_language
        descriptive_detail.original_language.language_code
      end
    end

    def bic_code
      descriptive_detail.bic_code if descriptive_detail
    end

    def imprints
      publishing_detail.imprints if publishing_detail
    end

    def main_publisher
      publishing_detail.main_publisher if publishing_detail
    end

    def main_imprint
      publishing_detail.imprint if publishing_detail
    end

    def product_supply_for(country)
      product_supplies.find do |ps|
        ps.markets.find do |mrkt|
          mrkt.territory and 
          mrkt.territory.valid_for?(country)
        end
      end
    end

    def product_supply_from_supply_detail_for(country='ES')
      product_supplies.find do |ps|
        ps.supply_detail.prices.any?{|price| price.valid_for?(country)}
      end
    end

    def price_amount(country='ES')
      current_price.try(:total_price_amount)
    end

    def current_price(country='ES')
      prod_supply = product_supply_for(country) || product_supply_from_supply_detail_for(country)
      prod_supply.current_price(country) if prod_supply
    end

    def valid_prices(country='ES')
      prod_supply = product_supply_for(country) || product_supply_from_supply_detail_for(country)
      prod_supply.try(:valid_prices, country) || []
    end

    def will_price_change?
      current_price.try(:end_date).present? || 
      (valid_prices-[current_price.try(:info_hash)]).any?{|price| (price[:start_date] && price[:start_date].future?)}
    end

    def when_will_price_change
      if will_price_change?
        price_change = current_price.try(:end_date) 
        if price_change.present?
          price_change.next_day
        else 
          prices = (valid_prices-[current_price.try(:info_hash)]).select{|price| (price[:start_date] && price[:start_date].future?)}
          prices.each do |p|
            price_change = p[:start_date] if price_change.blank? || price_change > p[:start_date]
          end
          price_change
        end
      end
    end

    def product_availability(country='ES')
      prod_supply = product_supply_for(country) || product_supply_from_supply_detail_for(country)
      prod_supply.available? if prod_supply
    end

    def excluding_taxes?(country='ES')
      prod_supply = product_supply_for(country) || product_supply_from_supply_detail_for(country)
      prod_supply.excluding_taxes?(country) if prod_supply
    end

    def presale_date?(country='ES')
      prod_supply = product_supply_for(country) || product_supply_from_supply_detail_for(country)
      prod_supply && prod_supply.availability_allow_presale? &&
      (prod_supply.presale_date.present? || (prod_supply.market_date.blank? && publishing_detail && publishing_detail.presale_date?))
    end

    def presale_date(country='ES')
      prod_supply = product_supply_for(country) || product_supply_from_supply_detail_for(country)
      if presale_date? and (prod_supply || publishing_detail)
        prod_supply.try(:presale_date) || publishing_detail.try(:presale_date)
      end      
    end

    def resources
      resources_hsh = {}      
      collateral_detail.supporting_resources.each_with_index do |sr, n|
        resources_hsh["#{n}_#{sr.content_type}"] = {'link' => sr.link,
                                                    'access' => sr.access}
      end if collateral_detail
      resources_hsh
    end

    def cover_url
      if collateral_detail
        cover_resource = collateral_detail.supporting_resources.detect{|sr| sr.content_type == 'covers'}
        cover_resource.link if cover_resource.present? and !cover_resource.is_a?(Array)
      end
    end

    def sample_pages
      if collateral_detail
        sample_resource = collateral_detail.supporting_resources.detect{|sr| sr.content_type == 'sample_content'}
        sample_resource.link if sample_resource.present? and !sample_resource.is_a?(Array)
      end      
    end

    def related_isbns
      if related_material && related_products = related_material.related_physical_books
        related_products.map(&:id_isbn13).compact
      else
        []
      end
    end

    def technical_protection?
      if descriptive_detail
        descriptive_detail.technical_protection?
      end
    end

    def publishing_date(country='ES')
      if product_supply = product_supply_for(country)
        product_supply.market_date
      end
    end

    # Reglas de publicación desgún Tagus. 
    # Los saleable_according... devuelven (por orden de prioridad):
    # - WORLD si en la lista de derechos se menciona al mundo y el país NO esta excluido
    # - El pais solicitado si existe en su lista de derechos.
    # - false si se especifica una lista de derechos pero no esta ni el pais ni WORLD.
    # - nil si no hay lista de derechos
    def saleable?(country='ES')
      saleable_price = saleable_according_to_price(country)
      saleable_ps = saleable_according_to_product_supply(country)
      saleable_sr = saleable_according_to_sales_rights(country)

      product_availability and
      ( [country, 'WORLD'].include?(saleable_price) or
        ( saleable_price == false and saleable_ps == 'WORLD' ) or
        ( saleable_price == nil and [country, 'WORLD'].include?(saleable_ps) ) or
        ( saleable_price == nil and saleable_ps == nil and [country, 'WORLD'].include?(saleable_sr) ))
    end

    def saleable_according_to_price(country='ES')
      outcome = nil
      product_supplies.each do |ps|
        (ps.try(:supply_detail).try(:prices)||[]).each do |price|
          price_territory = price.try(:territory)
          outcome = change_saleable(outcome, price_territory.validness_in(country)) if price_territory
        end
      end
      outcome
    end

    def saleable_according_to_product_supply(country='ES')
      outcome = nil
      product_supplies.each do |ps|
        ps.markets.each do |market|
          product_supply_territory = market.try(:territory)
          outcome = change_saleable(outcome, product_supply_territory.validness_in(country)) if product_supply_territory
        end
      end
      outcome
    end

    def saleable_according_to_sales_rights(country='ES')
      sales_rights_territory = publishing_detail.try(:sales_rights).try(:territory)
      sales_rights_territory.validness_in(country) if sales_rights_territory
    end

    def change_saleable(old_value, new_value)
      if old_value.nil? # Si es nil
        new_value
      elsif old_value.blank? && ![nil, false].include?(new_value) # Si es nil o false y el nuevo no lo es
        new_value
      elsif new_value == 'WORLD' # WORLD tiene prioridad sobre todo, incluido el país.
        new_value
      else
        old_value
      end
    end

  end
end
