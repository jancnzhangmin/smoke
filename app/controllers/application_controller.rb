class ApplicationController < ActionController::Base
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

  def sendsms#发送验证码
    conn = Faraday.new(:url => 'https://api.cloudfeng.com') do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    conn.params[:appKey]= Message.first.appkey
    conn.params[:appSecret]= Message.frist.secret
    conn.params[:phones]='15908775553'
    conn.params[:content]='【鹏一科技】您的验证码为：' + randnum + '，请于15分钟内输入验证，请勿向他人泄露。工作人员不会以任何方式向您索要短信验证码'
    request = conn.get do |req|
      req.url '/api/v2/sendSms.json'
    end
  end

  class Checksubscribeclass
    attr :status,true
    attr :powerstatu,true
    attr :power,true
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
    return checksubscribecla
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

    device = Device.find_by_sn(devicejson['data'].last['data']['sn'])
    if device
      device.power = devicejson['data'].last['data']['vol2']
      device.timestamp = devicejson['data'].last['timestamp']
      device.imsi = devicejson['data'].last['data']['imsi']
      device.swver = devicejson['data'].last['data']['swver']
      device.hwver = devicejson['data'].last['data']['hwver']
      if devicejson['data'].last['data']['alarmstatus'] == 1
        device.status = 1
      end
      device.save
    end
  end

  def randnum#随机6位验证码
    myrand = ''
    6.times do
      myrand +=rand(10).to_s
    end
    return myrand
  end

end

