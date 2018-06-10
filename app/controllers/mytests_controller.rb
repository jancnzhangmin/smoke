class MytestsController < ApplicationController
  before_action :set_mytest, only: [:show, :edit, :update, :destroy]

  # GET /mytests
  # GET /mytests.json
  def index
    @mytests = Mytest.all
  end

  # GET /mytests/1
  # GET /mytests/1.json
  def show
  end

  # GET /mytests/new
  def new
    @mytest = Mytest.new
  end

  # GET /mytests/1/edit
  def edit
  end

  # POST /mytests
  # POST /mytests.json
  def create
    @mytest = Mytest.new(mytest_params)

    respond_to do |format|
      if @mytest.save
        format.html { redirect_to @mytest, notice: 'Mytest was successfully created.' }
        format.json { render :show, status: :created, location: @mytest }
      else
        format.html { render :new }
        format.json { render json: @mytest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mytests/1
  # PATCH/PUT /mytests/1.json
  def update
    respond_to do |format|
      if @mytest.update(mytest_params)
        format.html { redirect_to @mytest, notice: 'Mytest was successfully updated.' }
        format.json { render :show, status: :ok, location: @mytest }
      else
        format.html { render :edit }
        format.json { render json: @mytest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mytests/1
  # DELETE /mytests/1.json
  def destroy
    @mytest.destroy
    respond_to do |format|
      format.html { redirect_to mytests_url, notice: 'Mytest was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mytest
      @mytest = Mytest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mytest_params
      params.require(:mytest).permit(:test)
    end
end
