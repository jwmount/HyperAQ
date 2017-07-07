class ScheduledSprinkleEventsController < ApplicationController
  before_action :set_scheduled_sprinkle_event, only: [:update]
  skip_before_action :verify_authenticity_token

  # PATCH/PUT /scheduled_sprinkle_events/1
  # PATCH/PUT /scheduled_sprinkle_events/1.json
  def update
    respond_to do |format|
      if @scheduled_sprinkle_event.manipulate_and_update(scheduled_sprinkle_event_params, request)
        format.html { redirect_to @scheduled_sprinkle_event, notice: 'Scheduled sprinkle event was successfully updated.' }
        format.json { render :show, status: :ok, location: @scheduled_sprinkle_event }
      else
        format.html { render :edit }
        format.json { render json: @scheduled_sprinkle_event.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scheduled_sprinkle_event
      @scheduled_sprinkle_event = ScheduledSprinkleEvent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scheduled_sprinkle_event_params
      params.require(:scheduled_sprinkle_event).permit(:sprinkle_id, :valve_id, :history_id, :valve_cmd)
    end
end
