class QuestionResponse < ActiveRecord::Base
  belongs_to :question
  belongs_to :answer
  belongs_to :quiz_attempt
end
