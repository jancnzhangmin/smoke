class MylogsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index

  end

  def subscribe
    result = request.body.read
    Mylog.create(log:result)
    render json:'{"status":"200"}'
  end
end
