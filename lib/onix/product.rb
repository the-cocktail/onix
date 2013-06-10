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
    
  end
end
