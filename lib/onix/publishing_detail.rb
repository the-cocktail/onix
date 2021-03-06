# coding: utf-8

module ONIX
  class PublishingDetail
    include ROXML

    xml_name "PublishingDetail"

    xml_accessor :imprint, :from => "Imprint", :as => ONIX::Imprint
    xml_accessor :publishers, :from => "Publisher", :as => [ONIX::Publisher]
    xml_accessor :publishing_status, :from => "PublishingStatus", :as => Fixnum
    xml_accessor :publishing_date, :from => "PublishingDate", :as => ONIX::PublishingDate
    xml_accessor :sales_rights, :from => "SalesRights", :as => ONIX::SalesRights


    def self.publishing_status_names
      {
        0 => 'Unspecified',
        1 => 'Cancelled',
        2 => 'Forthcoming',
        3 => 'Postponed indefinitely',
        4 => 'Active',
        5 => 'No longer our product',
        6 => 'Out of stock indefinitely',
        7 => 'Out of print',
        8 => 'Inactive',
        9 => 'Unknown',
        10 => 'Remaindered',
        11 => 'Withdrawn from sale',
        12 => 'Recalled',
        15 => 'Recalled',
        16 => 'Temporarily withdrawn from sale',
        17 => 'Permanently withdrawn from sale',
      }
    end

    def presale_date?
      publishing_date and publishing_date.full_date and publishing_date.full_date.future?
    end

    def presale_date
      publishing_date.full_date if presale_date?      
    end

    def initialize
      self.publishers = []
    end

    def main_publisher
      publishers.find{|pub| pub.publishing_role == 1 }
    end

    def date
      publishing_date.date if publishing_date
    end

    def available_in?(country)
      if  sales_rights and sales_rights.territory
        sales_rights.territory.valid_for?(country)# && (publishing_status==4)
        # La condicion de Activo en venta se desactiva por ahora porque suele venir en nil
      end
    end

    def status
      PublishingDetail.publishing_status_names[publishing_status]
    end

  end
end
