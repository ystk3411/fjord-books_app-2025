# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy]
  before_action :ensure_correct_user, only: %i[update destroy]

  def create
    comment = Comment.new(comment_params)
    comment.user = current_user

    if comment.save
      redirect_to comment.commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      render 'reports/show', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to @comment.commentable, notice: t('controllers.common.notice_update', name: Comment.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy

    redirect_to @comment.commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human), status: :see_other
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.expect(comment: %i[content commentable_id commentable_type])
  end

  def ensure_correct_user
    return unless @comment.user_id != current_user.id

    redirect_to @comment.commentable, alert: t('errors.messages.invalid_user')
  end
end
