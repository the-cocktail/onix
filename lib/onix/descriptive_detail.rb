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
    xml_accessor :contributors, :from => "Contributor", :as => [ONIX::Contributor]
    xml_accessor :languages, :from => "Language", :as => [ONIX::Language]
    xml_accessor :subjects, :from => "Subject", :as => [ONIX::Subject]

    def initialize
      self.title_details = []
      self.languages = []
      self.subjects = []
    end

    def multiple_items?
      product_composition and product_composition != 0
    end

    def digital?
      %w(EA EB EC ED).include? product_form
    end

    def content
      case product_form_detail
        when 'E101' then 'epub'
        when 'E102' then 'oeb'
        when 'E103' then 'doc'
        when 'E104' then 'docx'
        when 'E105' then 'html'
        when 'E106' then 'odf'
        when 'E107' then 'pdf'
        when 'E108' then 'pdf'
        when 'E109' then 'rtf'
      end
    end

    def book?
      primary_content_type == 10
    end

    def technical_protection?
      epub_technical_protection and epub_technical_protection != '00'
    end

    def technical_protection
      case epub_technical_protection
        when '01' then 'DRM'
        when '02' then 'Digital Watermarking'
        when '03' then 'Adobe DRM'
      end
    end

    # TODO title_type indica si es el titulo de la serie 
    # u otras muchas cosas (titulo traducido, abreviado ,alternativo, etc)
    # quiza hay que poner title details como un array en caso de que nos pases
    # mas de uno 
    def main_title_detail
      main = title_details.detect{|detail| detail.title_element and detail.title_element.title_element_level == 1 }
    end

    def secondary_title_details
      title_details - [main]
    end

    def title
      main_title_detail.title if main_title_detail
    end

    # Contributors
    ####################

    def main_contributor
      main = contributors.detect{|cont| cont.contributor_role == 'A01'}
      main ||= contributors.detect{|cont| cont.start_with? 'A'}
      main
    end

    def secondary_contributors
      contributors - [main_contributor]
    end

    # Subjects
    ####################

    def keywords
      keywords_subject = subjects.detect{|subj| subj.subject_scheme_identifier == 20 }
      keywords_subject.subject_heading_text if keywords_subject
    end



  end
end


