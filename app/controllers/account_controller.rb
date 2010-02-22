class AccountController < ApplicationController
  #layout  'scaffold'

  def summary
    @lastweek = Array.new
    @thisweek = Array.new
    @nextweek = Array.new
    @later = Array.new
    @distant = Array.new
    lastdate = firstdate = Date.today()
    
    @courses = @user.courses.each do |course|
      # Get this week's stuff
      lastdate = firstdate + (7-firstdate.wday)
      @thisweek  += course.quizzes.find(:all, :conditions => ['date >= ? AND date <= ?', firstdate.strftime("%Y-%m-%d"), lastdate.strftime("%Y-%m-%d")])
      @thisweek  += course.assignments.find(:all, :conditions => ['close_date >= ? AND close_date <= ?', firstdate.strftime("%Y-%m-%d"), lastdate.strftime("%Y-%m-%d")])
      
      # Advance to next week
      firstdate = lastdate
      lastdate = lastdate + 7
      @nextweek  += course.quizzes.find(:all, :conditions => ['date >= ? AND date <= ?', firstdate.strftime("%Y-%m-%d"), lastdate.strftime("%Y-%m-%d")])
      @nextweek  += course.assignments.find(:all, :conditions => ['close_date >= ? AND close_date <= ?', firstdate.strftime("%Y-%m-%d"), lastdate.strftime("%Y-%m-%d")])

      # Advance to two weeks further
      firstdate = lastdate
      lastdate = lastdate + 14
      @later  += course.quizzes.find(:all, :conditions => ['date >= ? AND date <= ?', firstdate.strftime("%Y-%m-%d"), lastdate.strftime("%Y-%m-%d")])
      @later  += course.assignments.find(:all, :conditions => ['close_date >= ? AND close_date <= ?', firstdate.strftime("%Y-%m-%d"), lastdate.strftime("%Y-%m-%d")])
      
      # And beyond...!
      firstdate = lastdate
      lastdate = course.end_date
      @distant  += course.quizzes.find(:all, :conditions => ['date >= ? AND date <= ?', firstdate.strftime("%Y-%m-%d"), lastdate.strftime("%Y-%m-%d")])
      @distant  += course.assignments.find(:all, :conditions => ['close_date >= ? AND close_date <= ?', firstdate.strftime("%Y-%m-%d"), lastdate.strftime("%Y-%m-%d")])

    end
    
  end

  def login
    if @user
      redirect_to :action => "welcome"
    else
      if request.post?
        if user = User.authenticate(params[:user_login], params[:user_password])
          logger.info("Logged in!")
          session[:user] = user.id
          flash['notice']  = "Login successful"
          redirect_back_or_default :controller => 'account', :action => "welcome"
        else
          flash.now['notice']  = "Login unsuccessful"

          @login = params[:user_login]
        end
      end
    end
  end
    
  def signup
    if(params[:user])
      
      @user = User.new(params[:user])

      if request.post? and @user.save
        @user = User.authenticate(@user.login, params[:user][:password])
        session[:user] = @user.id
        flash['notice']  = "Signup successful"
        redirect_back_or_default :action => "welcome"
      end      
    end
  end  
  
  def edit 
    
  end
  
  def update
    @user = User.find(params[:id])
    
    if(params[:user]['avatar'] != "")
      attachment = params[:user]['avatar']
      params[:user]['file'] = attachment.read
      params[:user]['file_type'] = attachment.content_type.chomp
      params[:user]['file_name'] = attachment.original_filename
    else 
      log "No avatar"
    end
   
    params[:user].delete('avatar') # let's remove the field from the hash, because there's no such field in the DB anyway.
    
    if @user.update_attributes(params[:user])
      @user.save
      flash['notice'] = 'Account information was successfully updated.'
      redirect_to :action => 'summary'
    else
      logger.info "Unable to update"
      redirect_to :action => 'edit'
    end
  end
  
  def grades
    @currentcourses = @user.courses
  end
  
  def logout
    session[:user] = nil
  end
    
  def avatar
     user = User.find(params[:id])
     send_data(user.file,
                :filename => user.file_name,
                :type => user.file_type, 
                :disposition => "inline")
  end
    
  def welcome
  end
  
end
