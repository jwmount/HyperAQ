class ScheduledSprinkleEvent < ApplicationRecord
  belongs_to :valve

  def manipulate_and_update(params, request)
    update(params)
  end

end
