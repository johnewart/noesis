class PostController < ApplicationController

  def new 
     @post = Post.new
     @topic = Topic.find(params[:topic])
  end

  def create
    @post = Post.new(params[:post])
    @post.topic = Topic.find(params[:topic][:id])
    @post.user = @user
    @post.timestamp = Date.now()
    if @post.save
      flash['notice'] = 'Post was successfully created.'
      redirect_to :action => 'show', :controller => 'topic', :id => params[:topic][:id]
    else
      render_action 'new'
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    post = Post.find(params[:id])
    topic_id = post.topic.id
    post.destroy()
    redirect_to :action => 'show', :id => topic_id, :controller => 'topic'
  end

end
