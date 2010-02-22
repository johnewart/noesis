class QuizAttempt < ActiveRecord::Base
   belongs_to :quiz
   belongs_to :user
   has_many :question_responses
   
   def score
     score = 0
     self.question_responses.each do |response|
       score += response.answer.value
     end
     
     return score
   end
end
