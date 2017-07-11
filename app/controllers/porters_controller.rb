class PortersController < ApplicationController
  before_action :set_porter, only: [:show, :edit, :update, :destroy]

  # GET /porters
  # GET /porters.json
  def index
    @porters = Porter.all
  end

  # GET /porters/1
  # GET /porters/1.json
  def show
  end

  # GET /porters/new
  def new
    @porter = Porter.new
  end

  # GET /porters/1/edit
  def edit
  end

  # POST /porters
  # POST /porters.json
  def create
    @porter = Porter.new(porter_params)

    respond_to do |format|
      if @porter.save
        format.html { redirect_to @porter, notice: 'Porter was successfully created.' }
        format.json { render :show, status: :created, location: @porter }
      else
        format.html { render :new }
        format.json { render json: @porter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /porters/1
  # PATCH/PUT /porters/1.json
  def update
    respond_to do |format|
      if @porter.manipulate_and_update(porter_params, request)
        format.html { redirect_to @porter, notice: 'Porter was successfully updated.' }
        format.json { render :show, status: :ok, location: @porter }
      else
        format.html { render :edit }
        format.json { render json: @porter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /porters/1
  # DELETE /porters/1.json
  def destroy
    @porter.destroy
    respond_to do |format|
      format.html { redirect_to porters_url, notice: 'Porter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_porter
      @porter = Porter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def porter_params
      params.require(:porter).permit(:host_name, :port_number)
    end
end
