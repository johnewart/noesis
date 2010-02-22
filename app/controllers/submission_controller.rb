
class SubmissionController < CourseComponent  
  before_filter :teacher_required, :only => ['show']

  def index 
    submission = FileSubmission.new(:user => @user, :assignment => Assignment.find(1))
    submission.save
    #@submissions = Submission.find(:all)
  end
  
  def list 
    @assignment = Assignment.find(params[:assignment])
  end
  
  def destroy
    submission = Submission.find(params[:id])
    submission.delete()
    redirect_to :action => "list"
  end
  
  def show
    
    @submission = Submission.find(params[:id])
    @points = Array.new()
    (@submission.assignment.points+1).times do |num| 
      @points << num
    end
  end
  
  def grade
    submission = Submission.find(params[:id])
    submission.comments = params[:submission][:comments]
    submission.score = params[:submission][:score]
    if submission.valid? 
      submission.save
      redirect_to :controller => 'assignment', :action => 'submissions', :id => submission.assignment.id
    else
      #reshow form with errors
      redirect_to :action => 'show', :id => params[:id]
    end
  end
  
  def download 
    submission = Submission.find(params[:id])
    send_data(submission.file,
              :filename => submission.file_name,
              :type => submission.file_type, 
              :disposition => "attachment")
  end
end
