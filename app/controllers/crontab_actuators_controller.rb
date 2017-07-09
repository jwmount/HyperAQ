class CrontabActuatorsController < ApplicationController
  before_action :set_crontab_actuator, only: [:show, :edit, :update, :destroy]

  # GET /crontab_actuators
  # GET /crontab_actuators.json
  def index
    @crontab_actuators = CrontabActuator.all
  end

  # GET /crontab_actuators/1
  # GET /crontab_actuators/1.json
  def show
  end

  # GET /crontab_actuators/new
  def new
    @crontab_actuator = CrontabActuator.new
  end

  # GET /crontab_actuators/1/edit
  def edit
  end

  # POST /crontab_actuators
  # POST /crontab_actuators.json
  def create
    @crontab_actuator = CrontabActuator.new(crontab_actuator_params)

    respond_to do |format|
      if @crontab_actuator.save
        format.html { redirect_to @crontab_actuator, notice: 'Crontab actuator was successfully created.' }
        format.json { render :show, status: :created, location: @crontab_actuator }
      else
        format.html { render :new }
        format.json { render json: @crontab_actuator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /crontab_actuators/1
  # PATCH/PUT /crontab_actuators/1.json
  def update
    respond_to do |format|
      if @crontab_actuator.update(crontab_actuator_params)
        format.html { redirect_to @crontab_actuator, notice: 'Crontab actuator was successfully updated.' }
        format.json { render :show, status: :ok, location: @crontab_actuator }
      else
        format.html { render :edit }
        format.json { render json: @crontab_actuator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /crontab_actuators/1
  # DELETE /crontab_actuators/1.json
  def destroy
    @crontab_actuator.destroy
    respond_to do |format|
      format.html { redirect_to crontab_actuators_url, notice: 'Crontab actuator was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_crontab_actuator
      @crontab_actuator = CrontabActuator.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def crontab_actuator_params
      params.require(:crontab_actuator).permit(:state)
    end
end
