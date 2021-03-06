#!/usr/bin/env ruby

#	alexa500.rb
#	Author: William Woodruff
#	------------------------
#	Scrapes the Alexa.com 'top sites' ranking for the 500 most trafficked
#	websites using Nokogiri and dumps them to stdout.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

require 'nokogiri'
require 'open-uri'

base_url = "http://www.alexa.com/topsites/global;"
sites = []

(0..20).each do |i|
	html = Nokogiri::HTML(open("#{base_url}#{i}").read)

	sites << html.css('li[class=site-listing]').map do |li|
		li.css('a').first.text
	end
end

puts sites.sort.uniq.join("\n")
