class Submission < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :user
  #validates_numericality_of :score
  
  def text?
    true
  end
  def file?
    true
  end
  
  #def print          
  #  logger.info("Submission")
  #  logger.info("ID: " + self.id.to_s)
  #  logger.info("Assignment: " + self.assignment_id.to_s)
  #  logger.info("User: " + self.user_id.to_s)
  #  logger.info("Submitted: " + self.submitted.to_s)    
  #end
  
  
  #protected 
  #def validate 
  #  errors.add(:score, "must be a positive number") unless score >= 0.01 
  #end 
  
end

