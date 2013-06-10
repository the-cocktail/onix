# coding: utf-8

module ONIX
  class RelatedMaterial
    include ROXML

    xml_name "RelatedMaterial"

    xml_accessor :related_product, :from => "RelatedProduct", :as => ONIX::RelatedProduct

    
  end
end
