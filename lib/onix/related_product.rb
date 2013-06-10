# coding: utf-8

module ONIX
  class RelatedProduct
    include ROXML

    xml_name "RelatedProduct"

    xml_accessor :product_relation_code, :from => "ProductRelationCode"
    xml_accessor :product_identifiers, :from => "ProductIdentifier", :as => [ONIX::ProductIdentifier]
    

    
  end
end
