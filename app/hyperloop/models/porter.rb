require 'models/application_record'
class Porter < ApplicationRecord
  def host_with_port
    "#{host_name}:#{port_number}"
  end

  # This method should cause a dummy Porter update.
  # The real attribute values must be
  def patch_request
    "PATCH /porters/{id} host_name=localhost&port_number=3000"
    HTTP.patch("/porters/#{Porter.first.id}.json") do |response|
      logger.info "response.body #{response.body}"
    end
  end

  if RUBY_ENGINE != 'opal'
    def manipulate_and_update(params, request)
      logger.info params
      params['host_name'] = `hostname` 
      params['port_number'] = request.port
      update(params)
    end
  end
end
