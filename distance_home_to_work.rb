#!/usr/bin/env ruby
require 'uri'
require 'net/http'
require 'json'

if ARGV[0].include? '-h'
  puts 'Usage: <home address> <home address>'
  exit 1 
end
home = URI.escape(ARGV[0])
work = URI.escape(ARGV[1])

home_to_work_url = "http://maps.googleapis.com/maps/api/distancematrix/json?origins=#{home}&destinations=#{work}&sensor=true&units=imperial"

def process_request url
  uri = URI(url)
  Net::HTTP.start(uri.host, uri.port) do |http|
    request = Net::HTTP::Get.new uri.request_uri
    response = http.request request
    data = JSON.parse(response.body)
    ret_val = []
    ret_val << data['rows'][0]['elements'][0]['distance']['text']
    ret_val << data['rows'][0]['elements'][0]['duration']['text']
    ret_val
  end

end

home_to_work_data = process_request home_to_work_url
puts "Distance from home to work is: #{home_to_work_data[0]}.  Duration from home to work is: #{home_to_work_data[1]}."
