require 'nokogiri'

module Awestruct
  class Page
    def abstract
      paragraphs = Nokogiri::HTML.parse(content).css('p')
      
      r = ""

      (0..1).each do |i|
        p = paragraphs[i]
        next if p.nil? or p.text.size == 0

        r += p.to_s
      end
      
      r += "<p><a href=\"#{url}\">Read more...</a></p>"
    end
  end
end
