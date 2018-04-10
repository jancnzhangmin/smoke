class YgsubscribesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    result = request.body.read
    Mylog.create(log:result.to_s)
    render json:'{"status":"200"}'
  end
end
