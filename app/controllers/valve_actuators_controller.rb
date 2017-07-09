class ValveActuatorsController < ApplicationController
  before_action :set_valve_actuator, only: [:show, :edit, :update, :destroy]

  # GET /valve_actuators
  # GET /valve_actuators.json
  def index
    @valve_actuators = ValveActuator.all
  end

  # GET /valve_actuators/1
  # GET /valve_actuators/1.json
  def show
  end

  # GET /valve_actuators/new
  def new
    @valve_actuator = ValveActuator.new
  end

  # GET /valve_actuators/1/edit
  def edit
  end

  # POST /valve_actuators
  # POST /valve_actuators.json
  def create
    @valve_actuator = ValveActuator.new(valve_actuator_params)

    respond_to do |format|
      if @valve_actuator.save
        format.html { redirect_to @valve_actuator, notice: 'Valve actuator was successfully created.' }
        format.json { render :show, status: :created, location: @valve_actuator }
      else
        format.html { render :new }
        format.json { render json: @valve_actuator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /valve_actuators/1
  # PATCH/PUT /valve_actuators/1.json
  def update
    respond_to do |format|
      if @valve_actuator.update(valve_actuator_params)
        format.html { redirect_to @valve_actuator, notice: 'Valve actuator was successfully updated.' }
        format.json { render :show, status: :ok, location: @valve_actuator }
      else
        format.html { render :edit }
        format.json { render json: @valve_actuator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /valve_actuators/1
  # DELETE /valve_actuators/1.json
  def destroy
    @valve_actuator.destroy
    respond_to do |format|
      format.html { redirect_to valve_actuators_url, notice: 'Valve actuator was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_valve_actuator
      @valve_actuator = ValveActuator.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def valve_actuator_params
      params.require(:valve_actuator).permit(:valve_id, :cmd)
    end
end
