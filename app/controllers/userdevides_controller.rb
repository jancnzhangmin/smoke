class UserdevidesController < ApplicationController

  def destroy
    user = User.find(params[:id])
    device = Device.find(params[:user_id])
    user.devices.destroy(device)
    redirect_to attchdevice_user_path(user)
  end

end
