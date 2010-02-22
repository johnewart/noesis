class AddSubmissions < ActiveRecord::Migration
  def self.up
	  ActiveRecord::Schema.define(:version => 1) do
      create_table "submissions", :id => true, :force => true do |t|
        t.string "type", :null => false
        t.integer "user_id", :null => false
        t.integer "assignment_id", :null => false
        t.binary "file", :null => true
        t.string "file_name", :null => true
        t.string "file_type", :null => true
        t.text "text", :null => true
        t.timestamp "submitted", :null => false
        t.float "score", :default => 0.0
      end
    end
  end
  
  def self.down
    drop_table "submissions"
  end
end