# coding: utf-8

module ONIX
  class Supplier
    include ROXML

    xml_name "Supplier"

    xml_accessor :supplier_role, :from => "SupplierRole", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :supplier_name, :from => "SupplierName"

    alias_method :name, :supplier_name 

  end
end
