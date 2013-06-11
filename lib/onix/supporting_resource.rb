# coding: utf-8

module ONIX
  class SupportingResource
    include ROXML

    xml_name "SupportingResource"

    xml_accessor :resource_content_type, :from => "ResourceContentType", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :content_audience, :from => "ContentAudience"
    xml_accessor :resource_mode, :from => "ResourceMode", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :resource_version, :from => "ResourceVersion", :as => ONIX::ResourceVersion

		def self.resource_content_types
    	{ 1 => :covers,
	    	2 => :back_covers,
	    	3 => :pack_covers,
	    	4 => :contributor_pictures,
	    	5 => :series_images,
	    	6 => :series_logos,
	    	9 => :publisher_logos }
    end

		def self.resource_modes
			{ 1 => :applications,
				2 => :audios,
				3 => :images,
				4 => :texts,
				5 => :videos,
				6 => :multimodes }    	
    end

    {1 => :linkable?, 2 => :downloadable?, 3 => :embeddable?}.each do |identifier, method_name|
    	send :define_method, method_name do
				resource_version and resource_version.resource_form == identifier
      end
    end

    def link
    	resource_version.resource_link if resource_version
    end

  end
end
