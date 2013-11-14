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
        ps.supply_detail.has_price_for?(country)
      end
    end

    def price_amount(country='ES')
      prod_supply = product_supply_for(country) || product_supply_from_supply_detail_for(country)
      prod_supply.price_amount_for(country) if prod_supply
    end

    def excluding_taxes?(country='ES')
      prod_supply = product_supply_for(country) || product_supply_from_supply_detail_for(country)
      prod_supply.excluding_taxes?(country)
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

    def saleable?(country='ES')
      # product_supply_for(country).try(:published?) and                      #MarketPublishingStatus y ProductSupply
      publishing_detail and publishing_detail.available_in?(country) and      #SalesRights
      price_amount.present?
    end

  end
end
