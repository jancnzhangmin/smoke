class DevicemapsController < ApplicationController
  before_action {checkauth 'device_map'}
  def index

  end

  def getdevice
    device = Device.all
    render json: device.to_json
  end

end
