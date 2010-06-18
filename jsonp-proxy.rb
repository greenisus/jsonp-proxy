require 'rubygems'
require 'sinatra'
require "uri"
require 'net/http'
require 'net/https'
require 'json'

get '/' do
  headers = params['h'] ? JSON.parse(params['h']) : {}
  url = URI.parse(params['u'])
  
  if params['m'] == 'get'
    request = Net::HTTP::Get.new(url.path)
  elsif params['m'] == 'post'
    request = Net::HTTP::Post.new(url.path)
  elsif params['m'] == 'put'
    request = Net::HTTP::Put.new(url.path)
  elsif params['m'] == 'delete'
    request = Net::HTTP::Delete.new(url.path)
  elsif params['m'] == 'head'
    request = Net::HTTP::Head.new(url.path)
  else
    request = Net::HTTP::Get.new(url.path)
  end
  
  headers.each do |key, value|
    request.add_field(key, value)
  end
  
  request.body = params['b'] if params['b']
  
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  response = http.start do |http|
    http.request(request)
  end

  arg = "{ status: #{response.code}, headers: [#{response.each_name { }.to_json}], body: '#{response.body}' }"
  json = "#{params['jsonp']}(#{arg});"
end
