class AssignmentController < CourseComponent
      
  def index
    list
    render_action 'list'
  end

  def list
    @assignments = Assignment.find_all_by_course_id(session[:course].id, :order => "close_date ASC")
  end

  def show
    @assignment = Assignment.find(params[:id])
    
    if(@assignment.file?)
      @submissions = Submission.find(:all, :conditions => ["user_id = ? AND assignment_id = ?", @user.id, @assignment.id])
    else 
      @submissions = Submission.find(:first, :conditions => ["user_id = ? AND assignment_id = ?", @user.id, @assignment.id])
    end
  end
  
  def submissions
    @assignment = Assignment.find(params[:id])
    @submissions = @assignment.submissions
  end
  

  def submit
    assignment = Assignment.find(params[:id])
    @submission = nil
    
    if(assignment.file?)
      logger.info("New file submission")
      #params[:submission]['filename'] = params[:submission]['tmp_file'].original_filename.gsub(/[^a-zA-Z0-9.]/, '_') # This makes sure filenames are sane
      attachment = params[:submission]['attachment']
      params[:submission]['file'] = attachment.read
      params[:submission].delete('attachment') # let's remove the field from the hash, because there's no such field in the DB anyway.
      params[:submission]['file_type'] = attachment.content_type.chomp
      params[:submission]['file_name'] = attachment.original_filename
      @submission = FileSubmission.new(params[:submission]) 
    end 
    
    if(assignment.text?)  
      @submission = Submission.find(:first, :conditions => ["assignment_id = ? AND user_id = ?", params[:id], @user.id])
      
      if(@submission == nil)
        @submission = TextSubmission.new(params[:submission])
      else  
        @submission.update_attributes(params[:submission])
      end
    end

    if @submission
      @submission.user = @user
      @submission.assignment = assignment  
      @submission.submitted = DateTime.now
      @submission.save
    end
    
    redirect_to :action => 'show', :id => assignment
  end

  def create
    if params[:assignment][:type] == "FileAssignment"
      @assignment = FileAssignment.new(params[:assignment])
    else 
      @assignment = TextAssignment.new(params[:assignment])
    end
    
    @assignment.course_id = session[:course].id
    
    if @assignment.save
      flash['notice'] = 'Assignment was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def new 
    @assignment = Assignment.new
  end
  
  def edit
    @assignment = Assignment.find(params[:id])
  end

  def update
    @assignment = Assignment.find(params[:id])
    if @assignment.update_attributes(params[:assignment])
      flash['notice'] = 'Assignment was successfully updated.'
      redirect_to :action => 'show', :id => @assignment
    else
      render_action 'edit'
    end
  end

  def destroy
    Assignment.find(params[:id]).destroy
    redirect_to :action => 'list'
  end 
  
  def preview 
     @preview =  params[:text]
   	 render :inline => "<%= textilize(@preview) %>"
  end
  
end
