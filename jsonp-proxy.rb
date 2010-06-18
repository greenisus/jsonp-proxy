require 'rubygems'
require 'sinatra'
require "uri"
require 'net/http'
require 'net/https'
require 'json'

get '/' do
  headers = params['h'] ? JSON.parse(params['h']) : {}
  url = URI.parse(params['u'])
  request = Net::HTTP::Get.new(url.path)
  headers.each do |key, value|
    request.add_field(key, value)
  end
  
  # TODO: request method
  # TODO: set body
  
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  response = http.start do |http|
    http.request(request)
  end

  arg = "{ status: #{response.code}, headers: [#{response.each_name { }.to_json}], body: '#{response.body}' }"
  json = "#{params['jsonp']}(#{arg});"
end
