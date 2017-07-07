class WaterManagersController < ApplicationController
  before_action :set_water_manager, only: [:show, :edit, :update, :destroy]

  # GET /water_managers.json
  def index
    @water_managers = WaterManager.all
  end

  # PATCH/PUT /water_managers/1.json
  def update
    respond_to do |format|
      # updating this record causes a side effect of building a crontab file.
      # handle the side effect(s) of a database update prior to actually doing the update
      if @water_manager.manipulate_and_update(water_manager_params, request)
        format.html { redirect_to @water_manager, notice: 'Water manager was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: @water_manager.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_water_manager
      @water_manager = WaterManager.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def water_manager_params
      params.require(:water_manager).permit(:state, :id, :http_host)
    end
end
