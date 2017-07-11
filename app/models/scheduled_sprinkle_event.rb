class ScheduledSprinkleEvent < ApplicationRecord
  belongs_to :valve

  if RUBY_ENGINE != 'opal'

    def logger
      WaterManager.first.logger
    end

    def manipulate_and_update(params, request)
      logger.info "ScheduledSprinkleEvent.manipulate_and_update()"
      update(params)
      
    end
  end

end
