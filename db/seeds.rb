# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
config = Config.all
if config.count == 0
  Config.create(appid:'2018031201',secret:'Y1QsP9E5rHbSUpcmsWNsjDz1tSxyfmKyUIpPTT4o',ioturl:'https://sec.xh8400.cn',callbackurl:'http://admin.wulianshenghuo.cn')
  puts 'Iot初始化成功'
else
  puts 'Iot已存在'
end

message = Message.find_by_keyword('cloudfeng')
if !message
  Message.create(appkey:'UYBbYmzhtBl32YTdeJN712ew6M0Hm8ot',secret:'5b5972316e8e68117c8cc73a5e069e308571',name:'专信云',isdefault:0,keyword:'cloudfeng')
  puts '专信云初始化成功'
else
  puts '专信云已存在'
end

message = Message.find_by_keyword('yuntongxun')
if !message
  Message.create(accountsid:'8aaf070863a9d3560163aadda39600f4',auth_token:'fd86fc0d1bec4695b48f6e5fb6820ed5',appid:'8aaf070863a9d3560163aadda3fe00fb',name:'云通讯',isdefault:0,keyword:'yuntongxun')
  puts '云通讯初始化成功'
else
  puts '云通讯已存在'
end

message = Message.find_by_isdefault(1)
if !message
  message = Message.find_by_keyword('yuntongxun')
  message.isdefault = 1
  message.save
  puts '短信通道默认设置为云通讯'
end

admin = Admin.find_by_login('admin')
if admin
  puts '系统管理员已存在'
else
  Admin.create(username:'系统管理员',login:'admin',password:'admin',password_confirmation:'admin',status:'1')
  puts '系统管理初始化成功'
end
