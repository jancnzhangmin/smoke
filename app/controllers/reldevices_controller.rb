class ReldevicesController < ApplicationController

  def new
    @user = User.find(params[:user_id])
  end

  def create
    @err=''
    user = User.find(params[:user_id])
    device = Device.find_by_sn(params[:sn])
    if device
      device.deleteflag = 0
      device.save
      user.devices << device
      redirect_to attchdevice_user_path(user)
    else
      @err = '绑定失败，原因：无些设备'
      redirect_to new_user_reldevice_path(user)
    end
  end

end
