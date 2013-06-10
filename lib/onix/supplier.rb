# coding: utf-8

module ONIX
  class Supplier
    include ROXML

    xml_name "Supplier"

    xml_accessor :supplier_role, :from => "SupplierRole"
    xml_accessor :supplier_name, :from => "SupplierName"

  end
end
