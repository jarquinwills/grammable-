class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create 
    @gram = Gram.find_by_id(params[:id])
    return render_not_found if @gram.blank?
    @comment = @gram.comments.create(comment_params.merge(user: user_id))
    redirect_to root_path
  end

  private

  def render_not_found(status=:not_found)
    render plain: "#{status.to_s.titleize} :(", status: status
  end

  def comment_params
    params.require(:comment).permit(:message)
  end
end
