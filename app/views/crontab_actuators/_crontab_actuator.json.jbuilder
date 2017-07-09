json.extract! crontab_actuator, :id, :state, :created_at, :updated_at
json.url crontab_actuator_url(crontab_actuator, format: :json)
