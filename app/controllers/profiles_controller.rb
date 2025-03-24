# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: %i[show edit update]
  before_action :set_user
  before_action :set_user_profile_form, only: %i[edit update]
  
  def show
    @profile = Profile.find_by(user_id: current_user.id)
    @my_memos = current_user.memos.order(created_at: :desc)
  end

  def edit
    if current_user.profile.nil?
      @profile = Profile.new(user_id: current_user.id)
    else
      @profile = current_user.profile
    end
    render :edit
  end

  def update
    if @user_profile_form.save(user_profile_form_params)
      redirect_to user_profile_path(current_user.id), flash: { notice: "プロフィールを更新しました" }
    else
      flash[:alert] = "更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_profile_form_params
    params.require(:user_profile_form).permit(:nickname, :image)
  end

  def set_user_profile_form
    @profile = @user.profile
    @user_profile_form = UserProfileForm.new(@user, @profile)
  end

  def set_user
    @user = User.find(current_user.id)
  end
end
