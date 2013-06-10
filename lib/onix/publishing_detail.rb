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

  end
end
