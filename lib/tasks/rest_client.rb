# lib/tasks/rest_client.rb
require 'rest-client'
require 'json'

url = 'http://localhost:2017/porters/1'
response = RestClient.get(url)
puts JSON.parse(response)

