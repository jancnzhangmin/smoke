class ApplicationController < ActionController::Base
  # reset captcha code after each request for security


  #coding:utf-8

  protect_from_forgery with: :exception
  def gettoken#获取access_token
    access_token = ''
    access =Accesstoken.first
    if !access
      access = Accesstoken.create(access_token:'123456',exptime:'2018-01-01 0:00:00')
    end
    if Time.new < access.exptime + 60
      access_token = access.access_token
    else
      conn = Faraday.new(:url => Config.first.ioturl) do |faraday|
        faraday.request :url_encoded # form-encode POST params
        faraday.response :logger # log requests to STDOUT
        faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
      end
      conn.params[:appId]= Config.first.appid
      conn.params[:secret]= Config.first.secret
      request = conn.post do |req|
        req.url '/api/v1/sec/login'
      end
      access_token = JSON.parse(request.body)['access_token']
      access.access_token=JSON.parse(request.body)['access_token']
      access.exptime = Time.now + JSON.parse(request.body)['expires_in'].to_i
      access.save

    end
    return access_token

  end

  def sendsms(openid,phone)#发送验证码
    myrand = randnum
    conn = Faraday.new(:url => 'https://api.cloudfeng.com') do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    conn.params[:appKey]= Message.first.appkey
    conn.params[:appSecret]= Message.first.secret
    conn.params[:phones]= phone
    conn.params[:content]='【鹏一科技】您的验证码为：' + myrand + '，请于15分钟内输入验证，请勿向他人泄露。工作人员不会以任何方式向您索要短信验证码'
    request = conn.get do |req|
      req.url '/api/v2/sendSms.json'
    end
    user = User.find_by_openid(openid)
    user.vercode = myrand.to_s
    user.vertime = Time.now
    user.save
  end

  def cloopensms
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    sigparameter = Digest::MD5.hexdigest('8aaf070863a9d3560163aadda39600f4fd86fc0d1bec4695b48f6e5fb6820ed5' + timestamp).upcase
    authorization = Base64.encode64('8aaf070863a9d3560163aadda39600f4' + ':' + timestamp).gsub(/\n/, "")
    #debugger
    conn = Faraday.new(:url => 'https://app.cloopen.com:8883') do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end

    conn.headers[:Accept]= 'application/json'
    conn.headers['Content-Type']= 'application/json;charset=utf-8'
    #conn.headers['Content-Length'] = '256'
    conn.headers[:Authorization]= authorization

    # conn.params[:appSecret]= Message.first.secret
    # conn.params[:phones]= phone
    # conn.params[:content]='【鹏一科技】您的验证码为：' + myrand + '，请于15分钟内输入验证，请勿向他人泄露。工作人员不会以任何方式向您索要短信验证码'
    conn.params[:sig] = sigparameter
    request = conn.post do |req|
      req.url '/2013-12-26/Accounts/8aaf070863a9d3560163aadda39600f4/SMS/TemplateSMS'
      req.body ='{"to":"15908775553","appId":"8aaf070863a9d3560163aadda3fe00fb","templateId":"252971","datas":["521547","15"]}'
    end
    debugger
    # user = User.find_by_openid(openid)
    # user.vercode = myrand.to_s
    # user.vertime = Time.now
    # user.save
  end

  class Checksubscribeclass
    attr :status,true
    attr :powerstatu,true
    attr :power,true
  end

  def subscribe
    conn = Faraday.new(:url => Config.first.ioturl) do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    conn.headers['Authorization'] = 'Bearer ' + gettoken
    conn.params[:appId] = Config.first.appid
    conn.params[:notifyType] = 'deviceDataChanged'
    conn.params[:callbackurl] = Config.first.callbackurl
    request = conn.post do |req|
      req.url '/api/v1/subscribe'
    end
  end

  def checksubscribe(sn)#检查设备订阅情况
    checksubscribecla = Checksubscribeclass.new
    checksubscribecla.status = '10000'#正常
    device = Device.find_by_sn(sn)
    if device
      checksubscribecla.status = '10001'#设备已存在
    else
      conn = Faraday.new(:url => Config.first.ioturl) do |faraday|
        faraday.request :url_encoded # form-encode POST params
        faraday.response :logger # log requests to STDOUT
        faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
      end
      conn.headers['Authorization'] = 'Bearer ' + gettoken
      conn.params[:appId] = Config.first.appid
      conn.params[:device_id] = sn
      request = conn.post do |req|
        req.url '/api/v1/devices'
      end
      if JSON.parse(request.body)['status'] == 'success'
        conn = Faraday.new(:url => Config.first.ioturl) do |faraday|
          faraday.request :url_encoded # form-encode POST params
          faraday.response :logger # log requests to STDOUT
          faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
        end
        conn.headers['Authorization'] = 'Bearer ' + gettoken
        conn.params[:appId] = Config.first.appid
        conn.params[:device_id] = sn
        request = conn.post do |req|
          req.url '/api/v1/getDevice'
        end
        checksubscribecla.powerstatu = JSON.parse(request.body)['data']['powerstatu']
        checksubscribecla.power = JSON.parse(request.body)['data']['power']
      else
        checksubscribecla.status = '10002'#无此设备
      end
    end
    devicecount = Device.where('sn = ? and deleteflag = ?',sn,1).count
    if devicecount > 0
      checksubscribecla.status = '10000'
    end
    return checksubscribecla.status
  end

  def getdevicehisory(sn)#获取设备历史数据
    conn = Faraday.new(:url => Config.first.ioturl) do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    conn.headers['Authorization'] = 'Bearer ' + gettoken
    conn.params[:appId] = Config.first.appid
    conn.params[:device_id] = sn
    request = conn.post do |req|
      req.url '/api/v1/deviceDataHistory'
    end
    devicejson = JSON.parse(request.body)
    devicejson['data'].each do |f|
      if f['data']
        device =  Devicehistorylist.find_by_ctime(f['data']['time'])
        if !device
          Devicehistorylist.create(sn:f['data']['sn'],imsi:f['data']['imsi'],swver:f['data']['swver'],hwver:f['data']['hwver'],vol:f['data']['vol'],alarmstatus:f['data']['alarmstatus'],rsrp:f['data']['rsrp'],sinr:f['data']['sinr'],wsc:f['data']['wsc'],ctime:f['data']['time'],vol2:f['data']['vol2'],ctimestramp:f['timestamp'])
        end
      end
    end

    if devicejson['data'].count > 0 && devicejson['data'].last['data']
      device = Device.find_by_sn(devicejson['data'].last['data']['sn'])
      if device
        device.power = devicejson['data'].last['data']['vol2']
        device.timestamp = devicejson['data'].last['timestamp']
        device.imsi = devicejson['data'].last['data']['imsi']
        device.swver = devicejson['data'].last['data']['swver']
        device.hwver = devicejson['data'].last['data']['hwver']
        if devicejson['data'].last['data']['alarmstatus'] == 1
          device.status = 1
        else
          device.status = 0
        end
        device.save
      end
    end

  end

  def randnum#随机6位验证码
    myrand = ''
    6.times do
      myrand +=rand(10).to_s
    end
    return myrand
  end

  def send_wxmessage(touser,template_id,url,topcolor,data)
    $client ||= WeixinAuthorize::Client.new("wx771002724b047b26", "f10556ba5c87e8091711ab88b70930c9")
    $client.send_template_msg(touser, template_id, url, topcolor, data)
  end

  def checkauth(auth)
    rolearr = Array.new
    admin = Admin.find(session[:userid])
    roles = admin.roles
    roles.each do |f|
      role = f.role.split(':')
      role.each do |r|
        rolearr.push r
      end
    end
    rolearr.uniq!
    if !rolearr.include?(auth)
      redirect_to noauths_path
    end
  end

end

