class AddForumTables < ActiveRecord::Migration
  def self.up
	  ActiveRecord::Schema.define(:version => 2) do
      create_table "topics", :id => true, :force => true do |t|
        t.string "title", :null => false
        t.integer "forum_id", :null => false
      end
      
      create_table "posts", :id => true, :force => true do |t|
        t.integer "topic_id", :null => false
        t.text "body"
        t.integer "user_id", :null => false
        t.timestamp "timestamp"
      end
    end
  end
  
  def self.down
    drop_table "posts"
    drop_table "topics"
  end
end

