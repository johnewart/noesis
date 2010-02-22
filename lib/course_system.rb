
module CourseSystem 

  def course_required
   if not protect?(action_name)
     return true  
   end

   if params[:course] 
     session[:course] = Course.find(params[:course])
     return true
   else
     if session[:course] 
       return true
     end
   end

   # store current location so that we can 
   # come back after the user logged in
   store_location
   # call overwriteable reaction to unauthorized access
   select_course
   return false 
  end
  
  # store current uri in  the session.
  # we can return to this location by calling return_location
  def store_location
    session[:return_to] = request.request_uri
  end

  # overwrite if you want to have special behavior in case the user is not authorized
  # to access the current operation. 
  # the default action is to redirect to the login screen
  # example use :
  # a popup window might just close itself for instance
  def select_course
    flash['message'] = "No course selected, you must choose a course before you can perform that action!"
    redirect_to :controller=>"/course", :action =>"list"
  end
end