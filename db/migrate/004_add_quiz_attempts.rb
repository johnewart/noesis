class AddQuizAttempts < ActiveRecord::Migration
  def self.up
	  ActiveRecord::Schema.define(:version => 3) do
      create_table "quiz_attempts", :force => true do |t|
        t.integer "quiz_id", :null => false
        t.integer "user_id", :null => false
        t.datetime "open", :null => false 
        t.datetime "close"
      end 

      create_table "question_responses", :force => true do |t|
        t.integer "quiz_attempt_id", :null => false
        t.integer "question_id", :null => false
        t.integer "answer_id", :null => false
      end
    end
  end
end