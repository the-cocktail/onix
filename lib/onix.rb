# coding: utf-8

require 'bigdecimal'
require 'cgi'
require 'singleton'
require 'roxml'
require 'andand'

module ONIX
  module Version #:nodoc:
    Major = 0
    Minor = 9
    Tiny  = 0

    String = [Major, Minor, Tiny].join('.')
  end

  class Formatters
    def self.decimal
      lambda do |val|
        if val.nil?
          nil
        elsif val.kind_of?(BigDecimal)
          val.to_s("F")
        else
          val.to_s
        end
      end
    end

    def self.yyyymmdd
      lambda do |val|
        if val.nil? || !val.respond_to?(:strftime)
          nil
        else
          val.strftime("%Y%m%d")
        end
      end
    end

    def self.two_digit
      lambda do |val|
        if val.nil?
          nil
        elsif val.to_i < 10
          "0#{val}"
        elsif val.to_i > 99
          val.to_s[-2,2]
        else
          val.to_s
        end
      end
    end
  end
end

# core files
# - ordering is important, classes need to be defined before any
#   other class can use them
require "onix/sender_identifier"
require "onix/addressee_identifier"
require "onix/header"
require "onix/territory"
require "onix/sales_rights"
require "onix/product_identifier"
require "onix/website"
require "onix/tax"
require "onix/price"
require "onix/supplier"
require "onix/publishing_date"
require "onix/supply_detail"
require "onix/imprint_identifier"
require "onix/imprint"
require "onix/market_date"
require "onix/market_publishing_detail"
require "onix/market"
require "onix/related_product"
require "onix/related_material"
require "onix/product_supply"
require "onix/publisher"
require "onix/publishing_detail"
require "onix/contributor"
require "onix/subject"
require "onix/language"
require "onix/title_element"
require "onix/title_detail"
require "onix/collection_identifier"
require "onix/collection"
require "onix/descriptive_detail"
require "onix/text_content"
require "onix/resource_version"
require "onix/supporting_resource"
require "onix/collateral_detail"
require "onix/series_identifier"
require "onix/stock"
require "onix/discount_coded"
require "onix/product"
require "onix/reader"
require "onix/writer"

# product wrappers
require "onix/simple_product"
require "onix/apa_product"

# misc
require "onix/lists"
require "onix/normaliser"
require "onix/code_list_extractor"
