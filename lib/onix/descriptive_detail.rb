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
      if epub_technical_protection 
        %w(01 03 04 05).include?(epub_technical_protection)
      else
        false
      end
    end

    def technical_protection
      case epub_technical_protection
        when '01' then 'DRM'
        when '02' then 'Digital Watermarking'
        when '03' then 'Adobe DRM'
      end
    end

    # Titles
    ####################

    def main_title_detail
      title_details.find{|td| td.title_type == 1 }
    end    

    def original_title_detail
      title_details.find{|td| td.title_type == 3 }
    end

    def title
      main_title_detail.title if main_title_detail
    end

    def title_vo
      original_title_detail.title if original_title_detail
    end

    def subtitle
      main_title_detail.subtitle if main_title_detail
    end

    def collection_title
      main_title_detail.collection_title if main_title_detail
    end

    def subcollection_title
      main_title_detail.subcollection_title if main_title_detail
    end

    # Contributors
    ####################

    def main_contributor
      main = contributors.detect{|cont| cont.contributor_role == 'A01'}
      main ||= contributors.detect{|cont| cont.contributor_role.start_with? 'A' and cont.contributor_role.gsub('A','').to_i < 15 }
      main
    end

    def main_contributors
      contributors.select{|cont| cont.contributor_role.start_with? 'A' and cont.contributor_role.gsub('A','').to_i < 15 }
    end

    def secondary_contributors
      contributors - [main_contributor]
    end

    # Languages
    ####################

    def main_language
      languages.find{|lang| lang.language_role == 1}
    end

    def original_language
      languages.find{|lang| lang.language_role == 2}
    end

    # Subjects
    ####################

    def keywords
      keywords_subject = subjects.find{|subj| subj.subject_scheme_identifier == 20 }
      keywords_subject.subject_heading_text if keywords_subject
    end

    def bic_code
      bic_subject = subjects.find{|subj| subj.subject_scheme_identifier == 12 }
      bic_subject.subject_code if bic_subject
    end

    def topics
      subjects.map{|subj| "#{subj.subject_scheme_identifier}-#{subj.subject_code}-#{subj.subject_heading_text}"}
    end


  end
end


