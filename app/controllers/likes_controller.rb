class LikesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!
  before_action :set_likeable

  def update
    if @likeable.liked_by?(current_user)
      @likeable.unlike(current_user)
    else
      @likeable.like(current_user)
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          dom_id(@likeable, :likes),
          partial: "shared/like_button",
          locals: {
            record: @likeable,
            parent: parent_resource
          }
        )
      end
    end
  end

  private

  def set_likeable
    if params[:menu_id]
      @likeable = Menu.find(params[:menu_id])
    elsif params[:post_comment_id]
      @likeable = PostComment.find(params[:post_comment_id])
    elsif params[:post_slug]
      @likeable = Post.find_by!(slug: params[:post_slug])
    else
      raise ActiveRecord::RecordNotFound
    end
  end

    def parent_resource
      case @likeable
      when Menu
        @likeable.place
      when PostComment
        @likeable.post
      else
        nil
      end
    end
end
