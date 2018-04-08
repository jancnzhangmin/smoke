class ReldevicesController < ApplicationController

  def new
    @user = User.find(params[:user_id])
  end

  def create
    user = User.find(params[:user_id])
    device = Device.find_by_sn(params[:sn])
    user.devices << device
    redirect_to attchdevice_user_path(user)
  end

end
