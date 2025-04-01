# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_memo, only: %i[create destroy]

  def create
    favorite = current_user.favorites.new(memo_id: @memo.id)
    respond_to do |format|
      if favorite.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("memo_#{@memo.id}_favorite", partial: 'memos/favorite',
                                                                                locals: { memo: @memo })
        end
      else
        format.html { redirect_to @memo, alert: t('alert.create_favorite') }
      end
    end
  end

  def destroy
    favorite = Favorite.find_by(id: params[:id])
    respond_to do |format|
      if favorite.destroy
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("memo_#{@memo.id}_favorite", partial: 'memos/favorite',
                                                                                locals: { memo: @memo })
        end
      else
        format.html { redirect_to @memo, alert: t('alert.destroy_favorite') }
      end
    end
  end

  private

  def set_memo
    @memo = Memo.find_by(id: params[:memo_id])
  end
end
