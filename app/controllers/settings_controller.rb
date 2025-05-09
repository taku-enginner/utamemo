# frozen_string_literal: true

class SettingsController < ApplicationController
  before_action :set_memo

  def edit
    @memo = Memo.find_by(id: params[:memo_id])
  end

  def update
    if @memo.update(update_params)
      flash[:notice] = t('notices.memo_setting_success')
      redirect_to edit_memo_settings_path(@memo.id)
    else
      flash[:alert] = t('alerts.memo_setting_fail')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_memo
    @memo = Memo.find_by(id: params[:memo_id])
  end

  def update_params
    params.permit(:publish, :memo_title)
  end
end
