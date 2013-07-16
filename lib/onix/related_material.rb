# coding: utf-8

module ONIX
  class RelatedMaterial
    include ROXML

    xml_name "RelatedMaterial"

    xml_accessor :related_products, :from => "RelatedProduct", :as => [ONIX::RelatedProduct]

    def related_physical_books
    	related_products.select{|rp| rp.product_relation_code == 13 }
    end

    

    
  end
end
