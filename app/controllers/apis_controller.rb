class ApisController < ApplicationController

  def checkuserauth #获取用户微信信息
    $client ||= WeixinAuthorize::Client.new("wx771002724b047b26", "f10556ba5c87e8091711ab88b70930c9")
    status = 0 #0用户已禁用 1正常用户 2具备管理权限
    user = User.find_by_openid(params[:openid])
    if user
      status = user.status
      if params[:openid].to_s != ''
        user_info = $client.user(params[:openid])
        result = user_info.result
        user.headurl = result['headimgurl']
        user.sex = result['sex']
        user.nickname = result['nickname']
        user.save
      end
    else
      if params[:openid].to_s != ''
        user_info = $client.user(params[:openid])
        result = user_info.result
        User.create(openid:params[:openid],headurl:result['headimgurl'],sex:result['sex'],status:1,nickname:result['nickname'],alertsms:1,alertwx:1)
        status = 1
      end
    end
    render json: params[:callback]+'({"status":'+ status.to_s + '})',content_type: "application/javascript"
  end

  def getuserinfo #获取用户基本信息
    user = User.find_by_openid(params[:openid])
    attchusercount = user.childrens.count
    render json: params[:callback]+'({"user":'+ user.to_json + ',"usercount":' + attchusercount.to_s + '})',content_type: "application/javascript"
  end

  def sign
    $client ||= WeixinAuthorize::Client.new("wx771002724b047b26", "f10556ba5c87e8091711ab88b70930c9")
    sign_package = $client.get_jssign_package(params[:url].split('#')[0])
    render json: params[:callback]+'('+ sign_package.to_json + ')',content_type: "application/javascript"
  end

  def sendvercode #发送验证码
    sendsms(params[:openid],params[:phone])
    render json: params[:callback]+'({"status":"200"})',content_type: "application/javascript"
  end



  def bindphone #绑定手机
    status = 0 #0验证码错误或超时 1成功
    user = User.find_by_openid(params[:openid])
    if user.vercode == params[:vercode] && user.vertime < Time.now + 15.minutes
      status = 1
      user.phone = params[:phone]
      user.save
    end
    render json: params[:callback]+'({"status":'+ status.to_s + '})',content_type: "application/javascript"
  end

  def changealertsms #是否接收短信报警
    user = User.find_by_openid(params[:openid])
    user.alertsms = params[:status]
    user.save
    render json: params[:callback]+'({"status":"200"})',content_type: "application/javascript"
  end

  def changealertswx #是否接收微信报警
    user = User.find_by_openid(params[:openid])
    user.alertwx = params[:status]
    user.save
    render json: params[:callback]+'({"status":"200"})',content_type: "application/javascript"
  end

  def checkdevice #检查设备是否注册
    check = checksubscribe(params[:sn])

    render json: params[:callback]+'({"status":'+ check.to_s + '})',content_type: "application/javascript"
  end

  def subscribedevice #注册设备
    device = Device.find_by_sn(params[:sn])
    if device
      device.model = params[:model]
      device.coordinate = params[:coor]
      device.address = params[:address]
      device.floor = params[:floor]
      device.deleteflag = 0
      device.save
    else
      device = Device.create(name:'烟感',sn:params[:sn],model:params[:model],coordinate:params[:coor],address:params[:address],floor:params[:floor])
    end

    user = User.find_by_openid(params[:openid])
    user.devices << device
    render json: params[:callback]+'({"status":"200"})',content_type: "application/javascript"
  end

  def getdevicelist #获取设备历史
    user = User.find_by_openid(params[:openid])
    devices = user.devices.order('id desc')
    render json: params[:callback]+'({"devices":'+ devices.to_json + '})',content_type: "application/javascript"
  end

  def getcanbingdevicelist #用户可绑定设备
    user = User.find_by_openid(params[:openid])
    attchdeviceids = User.find(params[:userid]).devices.ids
    attchdeviceids.push 0
    devices = user.devices.where('id not in(?)',attchdeviceids).order('id desc')
    render json: params[:callback]+'({"devices":'+ devices.to_json + '})',content_type: "application/javascript"
  end

  def getsingledevice #获取单设备信息
    device = Device.find(params[:id])
    render json: params[:callback]+'({"device":'+ device.to_json + '})',content_type: "application/javascript"
  end

  def getuserdevicehisory #获取单设备历史
    devicehistroy = Devicehistorylist.where('sn = ?',params[:sn]).order('id desc')
    render json: params[:callback]+'({"devicehistroy":'+ devicehistroy.to_json + '})',content_type: "application/javascript"
  end

  def binduser #绑定附属用户
    status = 0
    childrenuser = User.find_by_phone(params[:phone])
    if childrenuser
      parentuser = User.find_by_openid(params[:openid])
      if parentuser.id != childrenuser.id
        childrenuser.up_id = parentuser.id
        childrenuser.save
        status = 1
      else
        status = 2
      end
    end
    render json: params[:callback]+'({"status":'+ status.to_s + '})',content_type: "application/javascript"
  end

  class Userclass
    attr :id,true
    attr :openid,true
    attr :headurl,true
    attr :phone,true
    attr :sex,true
    attr :status,true
    attr :up_id,true
    attr :nickname,true
    attr :devicecount,true
  end

  def getchildrenuser #获取附属用户
    user = User.find_by_openid(params[:openid])
    childrenuser = user.childrens
    userarr = Array.new
    childrenuser.each do |f|
      usercla = Userclass.new
      usercla.id = f.id
      usercla.openid = f.openid
      usercla.headurl = f.headurl
      usercla.phone = f.phone
      usercla.sex = f.sex
      usercla.status = f.status
      usercla.up_id = f.up_id
      usercla.nickname = f.nickname
      usercla.devicecount = f.devices.count
      userarr.push usercla
    end
    render json: params[:callback]+'({"user":'+ userarr.to_json + '})',content_type: "application/javascript"
  end

  def getattchuserdetail
    user = User.find(params[:id])
    devices = user.devices
    render json: params[:callback]+'({"devices":'+ devices.to_json + '})',content_type: "application/javascript"
  end

  def getuserdevicelist
    user = User.find(params[:id])
    devices = user.devices.order('id desc')
    render json: params[:callback]+'({"devices":'+ devices.to_json + '})',content_type: "application/javascript"
  end

  def bindattchuserdevice #绑定用户设备
    user = User.find_by_id(params[:id])
    devices = Device.where('id in (?)',params[:deviceid])
    devices.each do |f|
      user.devices << f
    end
    render json: params[:callback]+'({"status":"200"})',content_type: "application/javascript"
  end

  def removedevice #移除附属用户设备绑定
    user = User.find(params[:userid])
    device = Device.find(params[:deviceid])
    user.devices.destroy(device)
    render json: params[:callback]+'({"status":"200"})',content_type: "application/javascript"
  end

  def getdevicehistroydetail #获取设备历史明细
    devicehistroydetail  = Devicehistorylist.find(params[:id])
    render json: params[:callback]+'({"devicehistroy":'+ devicehistroydetail.to_json + '})',content_type: "application/javascript"
  end

  def deletedevice #移除设备
    device = Device.find_by_sn(params[:sn])
    device.deleteflag = 1
    device.save
    users = device.users
    users.each do |user|
      user.devices.destroy device
      childrens = user.childrens
      childrens.each do |child|
        child.devices.destroy device
      end
    end
    render json: params[:callback]+'({"status":"200"})',content_type: "application/javascript"
  end

  def getdevicebysn
    status = '10001'
    device = Device.find_by_sn(params[:sn])
    if device
      status = '10000'
      render json: params[:callback]+'({"status": ' + status + ', "device":'+ device.to_json + '})',content_type: "application/javascript"
    else
      render json: params[:callback]+'({"status": ' + status + '})',content_type: "application/javascript"
    end
  end


end
