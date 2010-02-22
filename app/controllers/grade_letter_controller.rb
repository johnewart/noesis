class GradeLetterController < CourseComponent

  def index
    list
    render_action 'list'
  end  
  
  def edit
    @grade = GradeLetter.find(params[:id])
  end

  def list
    @grades = GradeLetter.find_all_by_course_id(session[:course].id, :order => "top DESC")
  end

   def create
     grade = GradeLetter.new(params[:grade])
     grade.course = session[:course]
     if grade.save
       flash['notice'] = 'Grade was successfully created.'
       redirect_to :action => 'list'
     else
       render_action 'new'
     end
   end
   
   def update
     grade = GradeLetter.find(params[:id])
     if grade.update_attributes(params[:grade])
       redirect_to :action => 'list'
     else
       render_action 'edit'
     end
   end

   def add_grade 
     @grade = GradeLetter.new
     @grade.letter = params[:gradeletter]
     @grade.top = params[:top]
     @grade.bottom = params[:bottom]
     @grade.course = session[:course]
     @grade.save
     render :partial
   end

end
