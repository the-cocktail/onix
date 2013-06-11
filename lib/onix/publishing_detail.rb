# coding: utf-8

module ONIX
  class PublishingDetail
    include ROXML

    xml_name "PublishingDetail"

    xml_accessor :imprints, :from => "Imprint", :as => [ONIX::Imprint]
    xml_accessor :publishers, :from => "Publisher", :as => [ONIX::Publisher]
    xml_accessor :publishing_status, :from => "PublishingStatus", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :publishing_date, :from => "PublishingDate", :as => ONIX::PublishingDate
    xml_accessor :sales_rights, :from => "SalesRights", :as => ONIX::SalesRights


    def initialize
      self.imprints = []
      self.publishers = []
    end

    def main_imprint
      imprints.detect{|imp| imprint_identifier and imprint_identifier.imprint_id_type == 1 }
    end

    def main_publisher
      publishers.detect{|pub| pub.publishing_role == 1 }
    end

    def date
      publishing_date.date if publishing_date
    end

    def available_in?(country)
      if sales_rights and sales_rights.territory and sales_rights.territory.countries_included
        sales_rights.territory.countries_included.include? country
      end
    end


  end
end
