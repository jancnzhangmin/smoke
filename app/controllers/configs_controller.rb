class ConfigsController < ApplicationController
 before_action {checkauth 'system_config'}
  before_action :set_config, only: [:show, :edit, :update, :destroy]
  def index
    #checksubscribe('aaa')
    @config = Config.first
    redirect_to edit_config_path(@config)
  end

  def edit

  end

  def new
    @config = Config.new
  end

  def create
    @config = Config.new(config_params)
    respond_to do |format|
      if @config.save
        format.html { redirect_to configs_path, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @config.update(config_params)
        subscribe
        format.html { redirect_to edit_config_path(@config), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @config }
      else
        format.html { render :edit }
        format.json { render json: @config.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @config.destroy
    respond_to do |format|
      format.html { redirect_to configs_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  def show

  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_config
    @config = Config.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def config_params
    params.require(:config).permit(:appid, :secret, :ioturl, :callbackurl)
  end

end
