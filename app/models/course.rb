class Course < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :assignments
  has_many :quizzes
end
