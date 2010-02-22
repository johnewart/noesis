class CreateDatabase < ActiveRecord::Migration
  def self.up
	ActiveRecord::Schema.define(:version => 0) do

	  create_table "answers", :force => true do |t|
	    t.integer "question_id", :null => false
	    t.text    "text"
	    t.float   "value"
	  end

	  create_table "assignments", :force => true do |t|
	    t.string  "name"
	    t.text    "description"
	    t.integer "points"
	    t.string  "type", :null => false
	    t.boolean "allowlate"
	    t.integer "course_id",   :null => false
	    t.date    "open_date"
	    t.date    "close_date"
	    t.boolean "hidden"
	  end

	  create_table "assignments_tags", :id => false, :force => true do |t|
	    t.integer "assignment_id", :null => false
	    t.integer "tag_id",        :null => false
	  end

	  create_table "courses", :force => true do |t|
	    t.string "name"
	    t.date   "start_date"
	    t.date   "end_date"
	    t.text   "description"
	  end

	  create_table "courses_users", :id => false, :force => true do |t|
	    t.integer "course_id", :null => false
	    t.integer "user_id",   :null => false
	  end

	  create_table "forums", :force => true do |t|
	    t.string  	"title"
	    t.text 		"description"
	    t.integer 	"course_id", :null => false
	  end

	  create_table "questions", :force => true do |t|
	    t.text    "text"
	    t.integer "value"
	  end

	  create_table "questions_quizzes", :id => false, :force => true do |t|
	    t.integer "quiz_id",     :null => false
	    t.integer "question_id", :null => false
	  end

	  create_table "quizzes", :force => true do |t|
	    t.string  "name"
	    t.date    "date"
	    t.time    "start_time"
	    t.time    "end_time"
	    t.integer "timelimit"
	    t.integer "points"
	    t.integer "course_id",  :null => false
	  end
    
	  create_table "tags", :force => true do |t|
	    t.string "label"
	  end

	  create_table "questions_tags", :id => false, :force => true do |t|
	    t.integer "tag_id",      :null => false
	    t.integer "question_id", :null => false
	  end

	  create_table "users", :force => true do |t|
	    t.string "login",     :limit => 32
	    t.string "password",  :limit => 40
	    t.string "email",     :limit => 60
	    t.string "firstname", :limit => 30
	    t.string "lastname",  :limit => 30
	    t.binary "file", :null => true
	    t.string "file_name", :null => true
      	    t.string "file_type", :null => true
	  end

	  add_index "users", ["email"], :name => "email", :unique => true
	  add_index "users", ["login"], :name => "login", :unique => true

	  create_table "users_courses", :id => false, :force => true do |t|
	    t.integer "user_id",   :null => false
	    t.integer "course_id", :null => false
	  end
	  
	  create_table "submissions", :id => true, :force => true do |t|
	    t.string "type", :null => false
	    t.integer "user_id", :null => false
	    t.integer "asssignment_id", :null => false
	    t.binary "file", :null => true
	    t.text "text", :null => true
	    t.timestamp "timestamp", :null => false
	    t.float "score", :default => 0.0
	  end
      end
  end

  def self.down
    # drop all the tables if you really need
    # to support migration back to version 0
  end
end
