class TagController < ApplicationController
  def list 
    @tags = Tag.find(:all)
  end
  
end
