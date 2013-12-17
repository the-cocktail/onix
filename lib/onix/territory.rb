# coding: utf-8

module ONIX
  class Territory
    include ROXML

    xml_name "Territory"

    xml_accessor :countries_inc,  from: 'CountriesIncluded'
    xml_accessor :countries_exc,  from: 'CountriesExcluded'
    xml_accessor :regions_inc,    from: 'RegionsIncluded'
    xml_accessor :regions_exc,    from: 'RegionsExcluded'

    def has_info?
      countries_inc.present? || countries_exc.present? || 
      regions_inc.present? || regions_exc.present?
    end

    { 'countries_included'  => 'countries_inc',
      'countries_excluded'  => 'countries_exc',
      'regions_included'    => 'regions_inc',
      'regions_excluded'    => 'regions_exc' }.each do |method_name, identifier|
      send :define_method, method_name do
        send(identifier).present? ? eval(identifier).try(:split, ' ') : []
      end
    end

    def valid_for?(country='ES')
    	( countries_included.include?(country)  or
        regions_included.include?(country)    or
        countries_included.include?('WORLD')  or
        regions_included.include?('WORLD') ) and 
      !(  countries_excluded.include?(country)  or
          regions_excluded.include?(country)    or
          countries_excluded.include?('WORLD')  or
          regions_excluded.include?('WORLD') ) 
    end

    # - WORLD si en el territory se menciona al mundo y el país NO esta excluido
    # - El pais solicitado si existe en su lista de derechos.
    # - false si se especifica una lista de derechos pero no esta ni el pais ni WORLD.
    def validness_in(country='ES')
      if  (countries_included.include?('WORLD') or regions_included.include?('WORLD')) and 
          !(countries_excluded.include?('WORLD') or regions_excluded.include?('WORLD') or
            countries_excluded.include?(country) or regions_excluded.include?(country))
        'WORLD'
      elsif (countries_included.include?(country) or regions_included.include?(country)) and
            !(countries_excluded.include?(country) or regions_excluded.include?(country))
        country
      else
        false
      end      
    end


  end
end
