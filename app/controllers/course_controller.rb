class CourseController < ApplicationController
  
  def index
    list
    render_action 'list'
  end  
  
  def view 
    @course = Course.find(params[:id])
    @assignments = Assignment.find_all_by_course_id(params[:id])
    @students = @course.users
  end
  
  def calendar
    @course = Course.find(params[:id])
    @assignments = Assignment.find_all_by_course_id(params[:id])
  end
  
 def ical
    assignments = Assignment.find_all_by_course_id(params[:id])
    quizzes = Quiz.find_all_by_course_id(params[:id])
    course = Course.find(params[:id])
    
    # Create a calendar with an event (standard method)
    cal = Icalendar::Calendar.new
    
    quizzes.each do |q|
      cal.event do 
        dtstart     q.date
        dtend       q.date
        summary     course.name + " " + q.name
        description ""
        klass       "PRIVATE"
      end
    end
    
    assignments.each do |a|
      cal.event do
        dtstart       a.close_date
        dtend         a.close_date
        summary       course.name + " " + a.name + " Due"
        description   a.description
        klass       "PRIVATE"
      end
      
    end

    render :text => cal.to_ical()
  end
  
  def list

    @courses = Course.find(:all)

    if (@courses.size > 0 and not @user.nil?)
    	@currentcourses = @user.courses
	    @availablecourses = @courses - @currentcourses
	  else 
		  redirect_to :action => 'new'
    end
  end
  
  def signup
    @course = Course.find(params[:id])
    @user.courses << @course
    if @user.save
       flash['notice'] = 'Successfully signed up.'
       redirect_to :action => 'list'
    end
  end
  
  def setactive
    if course = Course.find(params[:id])
      session[:course] = course
      redirect_to :action => 'list'
    else
      flash.now['notice']  = "No such course!"
    end
   end
   
   def new 
      @course = Course.new
   end
   
   def create
     @course = Course.new(params[:course])
     if @course.save
       flash['notice'] = 'Course was successfully created.'
       redirect_to :action => 'list'
     else
       render_action 'new'
     end
   end

   def edit
     @course = Course.find(params[:id])
   end

   def update
     @course = Course.find(params[:id])
     if @course.update_attributes(params[:course])
       flash['notice'] = 'course was successfully updated.'
       redirect_to :action => 'view', :id => @course
     else
       render_action 'edit'
     end
   end

   def destroy
     Course.find(params[:id]).destroy
     redirect_to :action => 'list'
   end
   
end
