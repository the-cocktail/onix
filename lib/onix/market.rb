# coding: utf-8

module ONIX
  class Market
    include ROXML

    xml_name "Market"
    
    xml_accessor :territory, :from => "Territory", :as => ONIX::Territory
    

  end
end
