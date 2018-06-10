class MessagesController < ApplicationController
  before_action {checkauth 'system_message'}
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  def index
    @messages = Message.all

    #@message = Message.first
    #redirect_to edit_message_path(@message)
  end

  def edit

  end

  def update
    messages = Message.all
    messages.each do |f|
      if f.isdefault == 1
        f.isdefault = 0
        f.save
      end
    end
    respond_to do |format|
      if @message.update(message_params)
        @message.isdefault = 1
        @message.save
        format.html { redirect_to messages_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_message
    @message = Message.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def message_params
    params.require(:message).permit(:appkey, :secret, :accountsid, :auth_token, :appid, :isdefault, :keyword, :name)
  end

end
