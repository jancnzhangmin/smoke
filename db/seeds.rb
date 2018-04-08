# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
config = Config.all
if config.count == 0
  Config.create(appid:'2018031201',secret:'Y1QsP9E5rHbSUpcmsWNsjDz1tSxyfmKyUIpPTT4o',ioturl:'https://sec.xh8400.cn',callbackurl:'http://yangan.posan.biz')
end

message = Message.all
if message.count == 0
  Message.create(appkey:'UYBbYmzhtBl32YTdeJN712ew6M0Hm8ot',secret:'5b5972316e8e68117c8cc73a5e069e308571')
end
