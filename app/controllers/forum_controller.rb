class ForumController < CourseComponent

    def index
      list
      render_action 'list'
    end  

    def show 
      @forum = Forum.find(params[:id])
    end

    def list
      @forums = Forum.find_all_by_course_id(session[:course].id, :order => "title ASC")
      
    end

     def create
       @forum = Forum.new(params[:forum])
       @forum.course = session[:course]
       if @forum.save
         flash['notice'] = 'Forum was successfully created.'
         redirect_to :action => 'edit', :id => @forum
       else
         render_action 'new'
       end
     end

     def edit
       @forum = Forum.find(params[:id])
     end

     def update
       @forum = Forum.find(params[:id])
       if @forum.update_attributes(params[:forum])
         flash['notice'] = 'Forum was successfully updated.'
         redirect_to :action => 'show', :id => @forum
       else
         render_action 'edit'
       end
     end

     def destroy
      forum = Forum.find(params[:id])
      forum.topics.each do |topic| 
        topic.destroy()
      end
      forum.destroy()
      redirect_to :action => 'list'
     end
end
