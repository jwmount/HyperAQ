require 'models/application_record'
require 'time'

class Valve < ApplicationRecord
  has_many :sprinkles
  # has_many :histories
  # has_many :scheduled_sprinkle_events
  # has_many :histories, foreign_key: "history_id", class_name: "History" # I think that is right...
  has_many :histories #, inverse_of: :valve
  #has_many :scheduled_sprinkle_events
end

