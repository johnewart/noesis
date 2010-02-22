# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require_dependency "login_system"
require_dependency "calendarhelper"
require_dependency "calendarmaker"
require_dependency "course_system"
#require_library_or_gem RedCloth 

class ApplicationController < ActionController::Base
  include LoginSystem
  include CourseSystem  
  helper CalendarHelper
  helper CalendarMaker
  layout "layouts/standard" 
  before_filter :load_user
  #before_filter :login_required, :except => [:login, :signup]
  
  def paginate_collection(collection, options = {})
     default_options = {:per_page => 10, :page => 1}
     options = default_options.merge options
     logger.info("Collection size: " + collection.size.to_s)

     pages = Paginator.new self, collection.size, options[:per_page], options[:page]
     first = pages.current.offset
     last = [first + options[:per_page], collection.size].min
     slice = collection[first...last]
     return [pages, slice]
  end
  
end
