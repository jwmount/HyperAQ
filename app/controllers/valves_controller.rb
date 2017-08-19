class ValvesController < ApplicationController
  before_action :set_valve, only: [:update]

  # GET /valves
  # GET /valves.json
  # def index
  #   @valves = Valve.all
  # end

  # GET /valves/1
  # GET /valves/1.json
  # def show
  # end

  # GET /valves/new
  # def new
  #   @valve = Valve.new
  # end

  # # GET /valves/1/edit
  # def edit
  # end

  # POST /valves
  # POST /valves.json
  # def create
  #   @valve = Valve.new(valve_params)

  #   respond_to do |format|
  #     if @valve.save
  #       format.html { redirect_to @valve, notice: 'Valve was successfully created.' }
  #       format.json { render :show, status: :created, location: @valve }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @valve.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /valves/1
  # PATCH/PUT /valves/1.json
  def update
    respond_to do |format|
      if @valve.manipulate_and_update(valve_params, request)
        format.html { redirect_to @valve, notice: 'Valve was successfully updated.' }
        format.json { render :show, status: :ok, location: @valve }
      else
        format.html { render :edit }
        format.json { render json: @valve.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /valves/1
  # DELETE /valves/1.json
  # def destroy
  #   @valve.destroy
  #   respond_to do |format|
  #     format.html { redirect_to valves_url, notice: 'Valve was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_valve
      @valve = Valve.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def valve_params
      params.require(:valve).permit(:name, :gpio_pin, :active_sprinkle_id, :active_history_id, :cmd, :base_time)
    end
end
