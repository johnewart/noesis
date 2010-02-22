class TopicController < CourseComponent

  def new 
     @topic = Topic.new
     @forum = Forum.find(params[:forum])
  end

  def create
    @topic = Topic.new(params[:topic])
    @topic.forum = Forum.find(params[:forum][:id])
    
    if @topic.save
      post = Post.new(params[:post])   
      post.user = @user
      post.topic = @topic
      post.timestamp = Date.now()
      post.save
      
      @topic.posts << post
      @topic.save
      
      flash['notice'] = 'Topic was successfully created.'
      redirect_to :action => 'show', :controller => 'forum', :id => params[:forum][:id]
    else
      render_action 'new'
    end
  end
  
  def show
    @topic = Topic.find(params[:id])
  end

  def edit
    @topic = Topic.find(params[:id])
  end
    
  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(params[:topic])
      flash['notice'] = 'Topic was successfully updated.'
      redirect_to :action => 'show', :id => @topic
    else
      render_action 'edit'
    end
  end

end
