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
      product_identifiers.detect{|pi| pi.product_id_type == id}
    end

    { 3 => :id_gtin13,
      15 => :id_isbn13,
      1 => :id_propietary
    }.each do |identifier, method_name|
      send :define_method, method_name do
        identifier = product_identifier_by_id(identifier)
        identifier.id_value if identifier        
      end
    end

    def product_supply_for(country)
      product_supplies.detect do |ps|
        ps.market and 
        ps.market.territory and
        ps.market.territory.countries_included and 
        ps.market.territory.countries_included.include?(country)
      end
    end

    # Accesos a cosas más usadas
    ############################

    def collection
      descriptive_detail.collection
    end

    def title
      descriptive_detail.title
    end

    def imprints
      publishing_detail.imprints
    end

    def publishers
      publishing_detail.publishers
    end

  end
end
