class DevicehistorylistsController < ApplicationController

  def index
    @device = Device.find(params[:device_id])
    @devicehistorylists = Devicehistorylist.where('sn = ?',@device.sn).order('ctime desc').paginate(:page => params[:page], :per_page => 20)
  end

end
