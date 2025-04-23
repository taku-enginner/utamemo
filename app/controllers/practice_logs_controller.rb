# frozen_string_literal: true

class PracticeLogsController < ApplicationController
  before_action :authenticate_user!

  def index
    @practice_logs = PracticeLog.where(user_id: current_user.id).order(created_at: :desc)
  end

  def show
    # エラー処理書く。メモに無いidが渡されたとき
    @practice_log = PracticeLog.where(user_id: current_user).find(params[:id])
  end

  def new
    @user_practice_log = PracticeLog.new
  end

  def create
    @practice_log = PracticeLog.new(practicelog_params)
    @practice_log.user_id = current_user.id
    if @practice_log.save
      flash[:notice] = t('notices.practice_log_created')
      redirect_to user_practice_logs_path(current_user.id)
    else
      flash[:alert] = t('alerts.practice_log_failed')
      render :new, status: :unprocessable_entity
    end
  end

  def update; end

  def destroy
    @practice_log = PracticeLog.find(params[:id])
    if @practice_log.destroy
      flash[:notice] = t('notices.practice_log_deleted')
      redirect_to user_practice_logs_path(current_user.id)
    else
      flash.now[:alert] = t('alerts.practice_log_delete_failed')
      # renderはビューを直接レンダリングするので、ビューのファイル名を使う
      render :show, status: :unprocessable_entity
    end
  end

  private

  def practicelog_params
    params.require(:practice_log).permit(:song, :placeholder_memo, :practice_amount, :mood, :comment)
  end
end
