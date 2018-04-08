class DevicemapsController < ApplicationController
  def index

  end

  def getdevice
    device = Device.all
    render json: device.to_json
  end

end
