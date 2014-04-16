# coding: utf-8

module ONIX
  class SalesRights
    include ROXML

    xml_name "SalesRights"

    xml_accessor :sales_rights_type, :from => "SalesRightsType"
    xml_accessor :territory, :from => "Territory", :as => ONIX::Territory

    def valid?
    	%w(00 01 02).include? sales_rights_type
    end

  end
end
