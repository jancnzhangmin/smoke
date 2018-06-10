class RolesController < ApplicationController
  before_action {checkauth 'system_role'}
  before_action :set_role, only: [:show, :edit, :update, :destroy]
  def index
    @roles = Role.all.order('id desc').paginate(:page => params[:page], :per_page => 15)
  end

  def edit

  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(role_params)
    respond_to do |format|
      if @role.save
        format.html { redirect_to roles_path, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to roles_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @role }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to roles_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  def show

  end


  private
# Use callbacks to share common setup or constraints between actions.
  def set_role
    @role = Role.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def role_params
    params.require(:role).permit(:name, :role)
  end

end
