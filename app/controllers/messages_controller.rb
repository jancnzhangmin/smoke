class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  def index
    @message = Message.first
    redirect_to edit_message_path(@message)
  end

  def edit

  end

  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to edit_message_path(@message), notice: 'User was successfully updated.' }
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
    params.require(:message).permit(:appkey, :secret)
  end

end