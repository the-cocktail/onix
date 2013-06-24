# coding: utf-8

module ONIX
  class RelatedProduct
    include ROXML

    xml_name "RelatedProduct"

    xml_accessor :product_relation_code, :from => "ProductRelationCode", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :product_identifiers, :from => "ProductIdentifier", :as => [ONIX::ProductIdentifier]
    
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
    
  end
end
