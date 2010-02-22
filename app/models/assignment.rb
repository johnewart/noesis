class Assignment < ActiveRecord::Base
  belongs_to :course
  has_many :submissions, :order => 'file_name ASC'
  
  def file?
    false
  end
  def text?
    false
  end
  
  def days_left
    return self.close_date - Date.today()
  end
  
  def still_open?
    return Date.today() <= self.close_date
  end
  
  def past_due?
    return Date.today() >= self.close_date
  end
  
  def user_submission(userid)
    submission = Submission.find_by_user_id_and_assignment_id(userid, self.id)
    return submission
  end
end



