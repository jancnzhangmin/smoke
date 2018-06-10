class UsersController < ApplicationController
  before_action {checkauth 'user_user'}
  before_action :set_user, only: [:show, :edit, :update, :destroy, :refreshdevice]
  def index
    @users = User.all.order('id desc').paginate(:page => params[:page], :per_page => 15)
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
      if @user.update(user_params)
        format.html { redirect_to edit_user_path(@user), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  def show

  end

  def attchuser
    @currentuser = User.find(params[:id])
    @attchusers = @currentuser.childrens
  end

  def attchdevice
    @devices = User.find(params[:id]).devices.paginate(:page => params[:page], :per_page => 15)
  end

  def reldevice
    @user = User.find(params[:id])
  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:openid, :headurl, :phone, :sex, :status, :up_id, :device_id, :nickname)
  end

end
