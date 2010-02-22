class Question < ActiveRecord::Base
  has_and_belongs_to_many :quizzes
  has_many :answers
  has_and_belongs_to_many :tags
end