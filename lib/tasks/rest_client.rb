# lib/tasks/rest_client.rb
require 'rest-client'
require 'json'

url = 'http://localhost:3000/porters/1.json'
response = RestClient.post(url, 
  {:host_name => 'foobar', :port_number => '2999'}.to_json, 
  {content_type: :json, accept: :json}
)
puts JSON.parse(response)

