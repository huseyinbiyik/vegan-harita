class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  def index
    @posts = Post.approved.includes(:user, :post_topic, :rich_text_content).order(created_at: :desc).page(params[:page]).per(5)
  end

  def show
    @post_comments = @post.post_comments.approved.includes(:user, :rich_text_content).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = current_user.posts.new(post_params)
    @post.approve if current_user.approved?

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    return unless current_user == @post.user
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    return unless current_user == @post.user || current_user.admin?
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
    end
  end

  private
    def set_post
      @post = Post.find_by!(slug: params[:slug])
    end

    def post_params
      params.require(:post).permit(:title, :content, :post_topic_id)
    end
end
