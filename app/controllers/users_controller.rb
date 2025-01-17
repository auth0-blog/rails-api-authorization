class UsersController < ApplicationController
  before_action :authorize
  before_action :set_user, only: %i[ show update destroy ]
  
  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      update_openfga_relation if user_params[:manager_id]
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      update_openfga_relation if user_params[:manager_id]
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :auth0_id, :manager_id)
    end

    def update_openfga_relation
      OpenfgaService.update_relation("user:#{@user.id}", "manager", "user:#{user_params[:manager_id]}")
    end
end
