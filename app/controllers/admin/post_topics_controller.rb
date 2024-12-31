class Admin::PostTopicsController < ApplicationController
  before_action :set_admin_post_topic, only: %i[ show edit update destroy ]

  def index
    @post_topics = PostTopic.all
  end

  def show
  end

  def new
    @post_topic = PostTopic.new
  end

  def edit
  end

  def create
    @post_topic = PostTopic.new(post_topic_params)

    respond_to do |format|
      if @post_topic.save
        format.html { redirect_to admin_post_topic_url(@post_topic), notice: "Post topic was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post_topic.update(post_topic_params)
        format.html { redirect_to admin_post_topic_url(@post_topic), notice: "Post topic was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post_topic.destroy!

    respond_to do |format|
      format.html { redirect_to admin_post_topics_url, notice: "Post topic was successfully destroyed." }
    end
  end

  private
    def set_admin_post_topic
      @post_topic = PostTopic.find(params[:id])
    end

    def post_topic_params
      params.require(:post_topic).permit(:title)
    end
end
