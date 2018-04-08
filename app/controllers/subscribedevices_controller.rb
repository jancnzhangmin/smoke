class SubscribedevicesController < ApplicationController
  before_action :set_config, only: [:show, :edit, :update, :destroy]
  def new
    @subscribedevice = Device.new

  end

  def getdevicesubscribeinfo
    check = checksubscribe(params[:sn])
    render json: check.to_json
  end


end
