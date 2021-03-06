class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :skip_signed_in_user, only: [:new, :create]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find_by_id(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      #flash.now[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    # correct_user で実行済み
    # @user = User.find_by(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      #flash.now[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    if current_user?(user) && user.admin?
      redirect_to root_url
    else
      user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before actions

    def signed_in_user
      #redirect_to signin_url, notice: "Please sign in." unless signed_in?

      # 同上
      # unless signed_in?
      #   flash[:notice] = "Please sign in."
      #   redirect_to signin_url
      # end

      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def skip_signed_in_user
      if signed_in?
        redirect_to root_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
