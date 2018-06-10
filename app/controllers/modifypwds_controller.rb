class ModifypwdsController < ApplicationController
  def index
    @admin = Admin.find(session[:userid])
  end

  def create
    @message ='原密码错误'
    @status = 0
    admin = Admin.find_by_login(params[:admin][:login])
    if admin && admin.authenticate(params[:admin][:oldpassword])
      admin.username = params[:admin][:username]
      admin.password = params[:admin][:password]
      admin.password_confirmation = params[:admin][:password]
      admin.save
      @message = '重置密码成功'
      @status = 1
    end

  end


end
