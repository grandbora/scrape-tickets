require 'nokogiri'
require 'open-uri'
require 'json'

event_data = []

for page in 1..100 # loop end limit can be increased manually or can be scraped from the page

  puts 'PAGE ::::::::' + page.to_s
  doc = Nokogiri::HTML(open('http://www.wegottickets.com/searchresults/page/' + page.to_s + '/all'))

  doc.css('.TicketListing .ListingOuter .event_link').each do |event_link|
    
    event_page = Nokogiri::HTML(open(event_link.attribute('href')))

    title = event_page.css('#Page h1').text # 
    # puts title.text

    venue_logo = event_page.css('.VenueDetails .venue-logo')
    next if venue_logo.empty?

    venue = venue_logo.first.next_sibling.next_sibling
    venue_town = venue.css('.venuetown').text
    venue_name = venue.css('.venuename').text
    #puts venue_town
    #puts venue_name

    event_data.push([title, venue_town, venue_name])
  end
end

puts event_data.to_json
