class Quiz < ActiveRecord::Base
  belongs_to :course
  has_and_belongs_to_many :questions
  has_many :quiz_attempts
  
  def weeks_until
    days = self.days_until.to_i
    retval = ""
    if days > 7
      weeks = days / 7
      days = days - (weeks * 7)
      retval = weeks.to_s + " weeks"

      if days > 0
        retval += ", " + days.to_s + " days"
      end
    else 
      retval = days.to_s + " days"
    end

    return retval
  end
  
  def days_until
    return self.date - Date.today()
  end
end
