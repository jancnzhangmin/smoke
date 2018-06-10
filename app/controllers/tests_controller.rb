class TestsController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:test]
def index
  device = Device.last
  devicehistroy = Devicehistorylist.where('sn = ?',device.sn).last

  touser='oRDiF0yZcbnM35MgqULIDrWFDZ3I'
  template_id='Zq7IW5plM2ZMcJ_2kWQWsTwJsl1OtHwPluXR9QLmgfk'
  url='http://yangan.posan.biz/getopenids'
  topcolor='#173177'
  data={
      "first": {
          "value":"您的设备" + device.sn + "发生报警",
          "color":"#173177"
      },
      "keyword1":{
          "value":'烟雾报'
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

  def test


    cloopensms
  end

end
