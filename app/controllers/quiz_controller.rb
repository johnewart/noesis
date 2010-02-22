class QuizController < CourseComponent
  helper :application 
  
  def index
    list
    render_action 'list'
  end  

  def open
      quiz = Quiz.find(params[:id])
      
      if session[:quizattempt] != nil
        attempt = session[:quizattempt]
        logger.info("Quiz attempt existed in session!")
      else
        attempt = QuizAttempt.find(:first, 
           :conditions => ["quiz_id = ? and user_id = ?", quiz.id, @user.id]) 
      end
      
      if attempt == nil
        logger.info("Quiz attempt undefined, instantiating!")
        attempt = QuizAttempt.new()
        attempt.open = DateTime.now()
        attempt.quiz_id = quiz.id 
        attempt.user_id = @user.id
        attempt.save
      end
      
      logger.info("Quiz attempt ID: " + attempt.id.to_s)
      session[:quizattempt] = attempt
      
      if attempt.close == nil
        redirect_to :action => 'show', :id => quiz
      else
        render :partial => "attempt_closed", :layout => true
      end
  end
  
  def submit
      quiz = Quiz.find(params[:id])
      attempt = session[:quizattempt]
      
      if attempt != nil
        # We have an attempt, but we need to ensure it's the right one
        if attempt.quiz.id == quiz.id
          attempt.close = DateTime.now()
          attempt.save
          # Don't need this anymore...
          session[:quizattempt] = nil
        end
      end
      
      redirect_to :action => 'list'
  end
  
  
  def show
    # Check first if there is an active quiz attempt. If there isn't, 
    # we redirect to quiz listings
    if session[:quizattempt] != nil
      @quiz = Quiz.find(params[:id])
      #@questionpages, @questions = paginate_collection @quiz.questions, :page => params[:page], :per_page => 3
      @questions = @quiz.questions
    else 
      redirect_to :action => 'list'
    end
  end
  
  def showquestions 
    @quiz = Quiz.find(params[:quiz])
    @pages, @questions = paginate_collection @quiz.questions, :page => params[:page], :per_page => 3
    render :partial => "showquestions"
  end
  
  def list
    @quizzes = Quiz.find_all_by_course_id(session[:course].id, :order => "end_time ASC")
    
  end
  
  def setactive
    if quiz = Quiz.find(params[:id])
      session[:quiz] = quiz
      redirect_to :action => 'list'
    else
      flash.now['notice']  = "No such quiz!"
    end
   end
   
   def new 
      @quiz = Quiz.new
   end
   
   def create
     @quiz = Quiz.new(params[:quiz])
     @quiz.course = session[:course]
     if @quiz.save
       flash['notice'] = 'Quiz was successfully created.'
       redirect_to :action => 'list'
     else
       render_action 'new'
     end
   end
   
   def quiz_changed
     attempt = session[:quizattempt]
     questions =  params[:question]
     questions.each {|question_id, answer_id| 
       #response = QuestionResponse.find_by_quizattempt_and_question(attempt, question_id)
       response = QuestionResponse.find(:first, 
         :conditions => ["quiz_attempt_id = ? and question_id = ?", attempt.id, question_id]) 
       
       if response == nil
         response = QuestionResponse.new()
         response.quiz_attempt = attempt
         response.question_id = question_id
       end
       response.answer_id = answer_id
       response.save
     }
     render :nothing => true
   end

   def edit
     @quiz = Quiz.find(params[:id])
   end

   def update
     @quiz = Quiz.find(params[:id])
     if @quiz.update_attributes(params[:quiz])
       flash['notice'] = 'Quiz was successfully updated.'
       redirect_to :action => 'view', :id => @quiz
     else
       render_action 'edit'
     end
   end
   
   def add_question 
     quiz = Quiz.find(params[:quiz])
     @question = Question.find(params[:question])
     quiz.questions << @question
     render :partial => "add_question"
   end

   def remove_question 
     quiz = Quiz.find(params[:quiz])
     @question = Question.find(params[:question])
     quiz.questions = quiz.questions - @question
     render :partial => "remove_question"
   end

   def find_questions
      questiontext = "%" + params[:questiontext] + "%"
      @quiz = Quiz.find(params[:quiz])
      allquestions = Question.find(:all, :conditions => ['text LIKE ?', questiontext])
      currquestions = @quiz.questions
      @questions = allquestions - currquestions
      render :partial => "find_questions"
   end
   
   def remove_question
     quiz = Quiz.find(params[:quiz])
     question = Question.find(params[:question])
     quiz.questions.delete(question)
     redirect_to(:action => "edit", :id => quiz)
   end
   
   def paginate_questions
     unless params[:quiz].nil?
        @quiz = Quiz.find(params[:quiz])
        @question_pages = Paginator.new self, @quiz.questions.length, 2, params['page']
        @questions = @quiz.questions.find :all, 
                                         :limit  =>  @question_pages.items_per_page,
                                         :offset =>  @question_pages.current.offset 
        render :partial => "paginate_questions"
     end
   end
   
   def submissions 
     @quiz = Quiz.find(params[:id])
     @submissions = @quiz.quiz_attempts
   end

   def destroy
     Quiz.find(params[:id]).destroy
     redirect_to :action => 'list'
   end
end
