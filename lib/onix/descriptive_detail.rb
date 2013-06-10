# coding: utf-8

module ONIX
  class DescriptiveDetail
    include ROXML

    xml_name "DescriptiveDetail"

    xml_accessor :product_composition, :from => "ProductComposition", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :product_form, :from => "ProductForm"
    xml_accessor :product_form_detail, :from => "ProductFormDetail"
    xml_accessor :primary_content_type, :from => "PrimaryContentType", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :epub_technical_protection, :from => "EpubTechnicalProtection"
    xml_accessor :collection, :from => "Collection", :as => ONIX::Collection
    xml_accessor :title_details, :from => "TitleDetail", :as => [ONIX::TitleDetail]
    xml_accessor :contributor, :from => "Contributor", :as => ONIX::Contributor
    xml_accessor :languages, :from => "Language", :as => [ONIX::Language]
    xml_accessor :subjects, :from => "Subject", :as => [ONIX::Subject]


    def initialize
      self.title_details = []
      self.languages = []
      self.subjects = []
    end

  end
end
