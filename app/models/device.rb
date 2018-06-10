class Device < ApplicationRecord
  has_and_belongs_to_many :users

  def self.checkhistroy
    devices = Device.all
    devices.each do |f|
      devicehistroys = Devicehistorylist.where('sn = ? and alarmstatus = ?',f.sn,0)
      if devicehistroys.count > 0
        devicehistroy = devicehistroys.last
        if devicehistroy.ctimestramp < Time.now + 5.minutes && devicehistroy.ctimestramp <= Time.now + 30.minutes

        end
      else
        getdevicehistroy(f.sn)

      end
    end
    Devicelog.create(sn:'')
  end

  def self.getdevicehistroy(sn)
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

  def self.gettoken#获取access_token
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


end
