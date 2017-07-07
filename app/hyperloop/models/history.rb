require 'models/application_record'
class History < ApplicationRecord
  belongs_to :valve #, foreign_key: "history_id", class_name: "History", inverse_of: :histories
  # belongs_to :valve, inverse_of :histories
end
