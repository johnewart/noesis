class QuestionController < CourseComponent
  upload_status_for :upload                                                  

  def index
    list
    render_action 'list'
  end  

  def show 
    @question = Question.find(params[:id])
  end

  def list
    @questions = Question.find(:all)
    #@questionpages, @questions = paginate :question, :per_page => 5    
  end

   def create
     @question = Question.new(params[:question])
     if @question.save
       flash['notice'] = 'Question was successfully created.'
       redirect_to :action => 'edit', :id => @question
     else
       render_action 'new'
     end
   end

   def edit
     @question = Question.find(params[:id])
   end

   def update
     @question = Question.find(params[:id])
     if @question.update_attributes(params[:question])
       flash['notice'] = 'Question was successfully updated.'
       redirect_to :action => 'show', :id => @question
     else
       render_action 'edit'
     end
   end
      

   def upload2
     case request.method
       when :post
     	   @uploaded = "File uploaded!"
     end
   end   
   
   def upload 
      case request.method
       when :post
         @message = 'File uploaded: ' + params[:upload][:file].size.to_s

         upload_progress.message = "Simulating some file processing stage 1..."
         session.update
         sleep(3)

         upload_progress.message = "Continuing processing stage 2..."
         session.update
         sleep(3)

         #redirect_to :action => 'show'

         finish_upload_status "'#{@message}'"
       end
   end 
   
   def upload_status
      render :inline => '<%= upload_progress_status %> <div>Updated at <%= Time.now %></div>', :layout => false
   end

   def add_answer 
     question = Question.find(params[:question])
     @answer = Answer.new
     @answer.text = params[:answertext]
     @answer.value = params[:answervalue]
     question.answers << @answer
     render :partial => "add_answer"
   end

   def remove_answer 
     @question = Question.find(params[:question])
     @answer = Answer.find(params[:answer])
     @question.answers.delete(@answer)
     render :partial =>   "answer_list"
   end

   def destroy
     Question.find(params[:id]).destroy
     redirect_to :action => 'list'
   end
   
   
   def find_tags
 		tagtext = "%" + params[:tagtext] + "%"
 		@question = Question.find(params[:question])
 		alltags = Tag.find(:all, :conditions => ['label LIKE ?', tagtext])
 		currtags = @question.tags
 		@tags = alltags - currtags
 		render :partial => "find_tags"
 	 end

   def add_tag 
     question = Question.find(params[:question])
     @tag = Tag.find(params[:tag])
     question.tags << @tag
     render :partial
   end
   
   def add_and_create_tags
     question = Question.find(params[:question])
     @tags = []
     params[:tagtext].split(" ").each do |t|
       tag = Tag.new()
       tag.label = t
       tag.save()
       question.tags << tag
       @tags << tag
     end
     
     question.save()
     
     render :partial => "add_tags"
   end
   
   def destroy
    question = Question.find(params[:id])
    question.answers.each do |answer| 
      answer.destroy()
    end
    question.destroy()
    redirect_to :action => 'list'
   end
end


