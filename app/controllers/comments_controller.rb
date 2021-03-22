class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: :create

  expose :comment

  def create
    authorize commentable
    commentable.comments << comment
    comment.user = current_user
    comment.save
  end

  private

  def commentable
    @resource, @resource_id = request.path.split('/')[1, 2]
    @resource = @resource.singularize
    @resource.classify.safe_constantize.find(@resource_id)
  end

  def publish_comment
    return if comment.errors.any?
    question_id = commentable.class == Question ? commentable.id : commentable.question_id
    ActionCable.server.broadcast(
      "question_#{question_id}_comments",
      comment: comment,
      user: comment.user
    )
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end