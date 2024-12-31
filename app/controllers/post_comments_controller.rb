class PostCommentsController < ApplicationController
  before_action :set_post, only: %i[index edit update destroy create ]

  def index
    @post_comments = @post.post_comments.approved
  end


  def edit
  end

  def create
    @post_comment = @post.post_comments.build(post_comment_params)
    @post_comment.user = current_user
    @post_comment.approve if current_user.approved?

    respond_to do |format|
      if @post_comment.save
        format.html { redirect_to post__url(@post), notice: "Post comment was successfully created." }
        format.turbo_stream do
          flash.now[:notice] = "Post comment was successfully created."
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace('new_comment', partial: 'post_comments/form', locals: { post: @post, post_comment: @post_comment }) }

      end
    end
  end

  def update
    respond_to do |format|
      if @post_comment.update(post_comment_params)
        format.html { redirect_to post_comment_url(@post_comment), notice: "Post comment was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post_comment.destroy!

    respond_to do |format|
      format.html { redirect_to post_comments_url, notice: "Post comment was successfully destroyed." }
    end
  end

  private
    def set_post
      @post = Post.find_by(slug: params[:post_slug])
    end

    def post_comment_params
      params.require(:post_comment).permit(:content)
    end
end
