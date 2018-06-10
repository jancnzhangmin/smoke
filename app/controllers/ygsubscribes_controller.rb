class YgsubscribesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    result = JSON.parse(request.body.read)
    getdevicehisory(result['sn'])
    device = Device.find_by_sn(result['sn'])
    users = device.users
    users.each do |user|
      if user.phone && user.alertsms.to_s =='1' && device.status.to_s == '1'
        conn = Faraday.new(:url => 'https://api.cloudfeng.com') do |faraday|
          faraday.request :url_encoded # form-encode POST params
          faraday.response :logger # log requests to STDOUT
          faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
        end
        conn.params[:appKey]= Message.first.appkey
        conn.params[:appSecret]= Message.first.secret
        conn.params[:phones]= user.phone
        conn.params[:content]='【鹏一科技】您的设备：（' + device.sn + ')' + device.address + device.floor + '，发生了报警，时间：' + Time.parse(result['time']).strftime('%Y-%m-%d %H:%M:%S') + '，安全事件类型：烟雾报警，请尽快处理！'
        request = conn.get do |req|
          req.url '/api/v2/sendSms.json'
        end
      end

      if user.alertwx.to_s == '1' && device.status.to_s == '1'
        devicehistroy = Devicehistorylist.where('sn = ?',device.sn).last
        touser=user.openid
        template_id='Zq7IW5plM2ZMcJ_2kWQWsTwJsl1OtHwPluXR9QLmgfk'
        url='http://yangan.liushushu.com/getopenids'
        topcolor='#173177'
        data={
            "first": {
                "value":"您的设备" + result['sn'] + "发生报警",
                "color":"#173177"
            },
            "keyword1":{
                "value":'烟雾报警'
            },
            "keyword2": {
                "value":device.address + device.floor
            },
            "keyword3": {
                "value":devicehistroy.ctimestramp.strftime('%Y-%m-%d %H:%M:%S')
            },
            "remark":{
                "value":"请尽快处理！"
            }
        }
        send_wxmessage(touser,template_id,url,topcolor,data)#支付成功消息
      end
    end

    #Mylog.create(log:result.to_s)
    render json:'{"status":"200"}'
  end
end
