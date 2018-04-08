class DevicesController < ApplicationController

  before_action :set_device, only: [:show, :edit, :update, :destroy, :refreshdevice]
  def index
    @devices = Device.all.order('id desc').paginate(:page => params[:page], :per_page => 15)
  end

  def edit

  end

  def new
    @device = Device.new
  end

  def create
    @device = Device.new(device_params)
    respond_to do |format|
      if @device.save
        #getdevicehisory(@device.sn)
        format.html { redirect_to devices_path, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @device.update(device_params)
        format.html { redirect_to edit_device_path(@device), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @device }
      else
        format.html { render :edit }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end

  end


  def destroy
    @device.destroy
    respond_to do |format|
      format.html { redirect_to devices_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  def show

  end

  def getdevice
    conn = Faraday.new(:url => Config.first.ioturl) do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    conn.headers['Authorization'] = 'Bearer ' + gettoken
    conn.params[:appId] = Config.first.appid
    conn.params[:device_id] = sn
    request = conn.post do |req|
      req.url '/api/v1/getDevice'
    end
  end

  def refreshdevice
    getdevicehisory(@device.sn)
    redirect_to devices_path
  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_device
    @device = Device.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def device_params
    params.require(:device).permit(:name, :sn, :model, :coordinate, :address, :floor, :power, :powerstatu, :repottime, :status, :imsi, :timestamp, :swver, :hwver)
  end





end
