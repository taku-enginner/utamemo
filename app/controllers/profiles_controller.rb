# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: %i[show edit update my_memos]
  before_action :set_user
  before_action :set_profile
  before_action :set_user_profile_form, only: %i[edit update]

  def show
    @profile = Profile.find_by(user_id: current_user.id)
    @profile = Profile.create!(user_id: current_user.id) if @profile.nil?
  end

  def edit
    @profile = if current_user.profile.nil?
                 Profile.create!(user_id: current_user.id)
               else
                 current_user.profile
               end
  end

  def update
    if @user_profile_form.save(user_profile_form_params)
      flash[:notice] = t('notices.profile_edit_success')
      redirect_to edit_user_profile_path(current_user.id)
    else
      flash[:alert] = t('alert.profile_edit_fail')
      render :edit, status: :unprocessable_entity
    end
  end

  def my_memos
    @profile = Profile.find_by(user_id: current_user.id)
    @profile = Profile.create!(user_id: current_user.id) if @profile.nil?
    @my_memos = current_user.memos.includes(:artist, :song).order(created_at: :desc).page(params[:page]).per(5)
  end

  private

  def user_profile_form_params
    params.require(:user_profile_form).permit(:nickname, :image)
  end

  def set_user_profile_form
    @user_profile_form = UserProfileForm.new(@user, @profile)
  end

  def set_user
    @user = User.find_by(id: current_user.id)
  end

  def set_profile
    @profile = @user.profile
  end
end
