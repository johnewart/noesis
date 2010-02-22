# The Calendar Helper methods create HTML code for different variants of the
# Dynarch DHTML/JavaScript Calendar.
#
# Author: Michael Schuerig, <a href="mailto:michael@schuerig.de">michael@schuerig.de</a>, 2005
# Free for all uses. No warranty or anything. Comments welcome.
#
# Version 0.02:
# Always set calendar_options's ifFormat value to '%Y/%m/%d %H:%M:%S'
# so that the calendar recieves the object's time of day.  Previously,
# the '%c' formating used to set the initial date would be parsed by
# the JavaScript calendar correctly to find the date, but it would not
# pick up the time of day.
#
# Version 0.01:
# Original version by Michael Schuerig.
#

#
#
# == Prerequisites
#
# Get the latest version of the calendar package from
# <a href="http://www.dynarch.com/projects/calendar/">http://www.dynarch.com/projects/calendar/</a>
#
# == Installation
#
# You need to install at least these files from the jscalendar distribution
# in the +public+ directory of your project
#
#  public/
#      images/
#          calendar.gif [copied from img.gif]
#      javascripts/
#          calendar.js
#          calendar-setup.js
#          calendar-en.js
#      stylesheets/
#          calendar-system.css
#
# Then, in the head section of your page templates, possibly in a layout,
# include the necessary files like this:
#
#  <%= stylesheet_link_tag 'calendar-system.css' %>
#  <%= javascript_include_tag 'calendar', 'calendar-en', 'calendar-setup' %>
#
# == Common Options
#
# The +html_options+ argument is passed through mostly verbatim to the
# +text_field+, +hidden_field+, and +image_tag+ helpers.
# The +title+ attributes are handled specially, +field_title+ and
# +button_title+ appear only on the respective elements as +title+.
#
# The +calendar_options+ argument accepts all the options of the
# JavaScript +Calendar.setup+ method defined in +calendar-setup.js+.
# The ifFormat option for +Calendar.setup+ is set up with a default
# value that sets the calendar's date and time to the object's value,
# so only set it if you need to send less specific times to the
# calendar, such as not setting the number of seconds.

#
#
module CalendarMaker
  
  def miniCalendar(dayOffset = 0, numMonths = 3, title = "Calendar")
    startdate = Date.today() - dayOffset
    cal = CalendarGrid.build(startdate, numMonths)

    html = "<h3>" + title + "</h3>"
    
    cal.years.each do |y|
      html += "<table class='minicalendar''>"
      html += "<tr><th colspan='7'>" + y.year.to_s + "</th></tr>\n"

      y.months.each do |m|
        
        #Assignment.find(:all, :conditions => ["due >= ? AND due <= ?", startdate, enddate]).collect do |a|                        
        #  html += "<tr><td colspan='7'>" + a.name + "</td></tr>\n"
        #end
        
        html += "<tr><th colspan='7'>" + m.strftime("%B") + "</th></tr>\n"
        html += "<tr class='weekdays'><td>Sun</td><td>Mon</td><td>Tue</td><td>Wed</td><td>Thu</td><td>Fri</td><td>Sat</td></tr>\n"
        
        s = m.weeks.collect do |w|
          startdate = w.first.strftime("%Y-%m-%d")
          enddate = w.last.strftime("%Y-%m-%d")
          @assignments = Assignment.find(:all, :conditions => ['close_date >= ? AND close_date <= ?', startdate, enddate])
          #logger.info("Assignments: " + @assignments.to_s)
          html += "<tr>\n"
          w.collect do |day|
            
            if @assignments.size > 0
              found = false
              for i in  0...@assignments.size
                #logger.info("Close date: " + @assignments[i].close_date.to_s)
                #logger.info("Current day: " + day.strftime("%Y-%m-%d"))
                if @assignments[i].close_date.to_s == day.strftime("%Y-%m-%d")
                  #logger.info("MATCH!")
                  unless found 
                    html += "<td class='assignment'>" 
                  end
                  found = true
                end
              end
              unless found 
                html += "<td>"
              end
            else 
              html += "<td>"
            end
            html += "#{(day.proxy?) ? '* ' : day.strftime("%d")}" + "</td>" 
          end
          html += "</tr>\n"
        end
        
        #html +=  "<tr>" + s.join("</tr><tr>") + "</tr>"

      end
    end

    html += "</table>"
<<END
#{html}
END
  end
   
   
  def monthCalendar(monthOffset = 0)
    startdate = Date.today() - monthOffset*30
    cal = CalendarGrid.build(startdate, 1)
    html = ""
    cal.years.each do |y|
      html += "<table class='monthCalendar'>"

      y.months.each do |m|

        html += "<tr><th colspan='7'>" + m.strftime("%B") + " " + y.year.to_s + "</th></tr>\n"
        html += "<tr class='weekdays'><th>Sun</th><th>Mon</th><th>Tue</th><th>Wed</th><th>Thu</th><th>Fri</th><th>Sat</th></tr>\n"

        s = m.weeks.collect do |w|
          startdate = w.first.strftime("%Y-%m-%d")
          enddate = w.last.strftime("%Y-%m-%d")
          assignments = @course.assignments(:all, :conditions => ['close_date >= ? AND close_date <= ?', startdate, enddate])
          quizzes = @course.quizzes(:all, :conditions => ['date >= ? AND date <= ?', startdate, enddate])
          html += "<tr>\n"
          weekday = 0

          w.collect do |day|

            weekday = weekday + 1
            
            if(day.proxy?)
              html += "<td class='empty'>"
            else 
              if(day.strftime("%Y-%m-%d") == Date.today.strftime("%Y-%m-%d"))
                html += "<td class='today'>"
              else 
                if (weekday == 1) or (weekday == 7)
                  html += "<td class='weekend'>"
                else 
                  html += "<td>"
                end
              end
            end
            
            html += "<div class='day'> #{(day.proxy?) ? '&nbsp;' : day.strftime("%d")}</div>"
            
            if assignments.size > 0
              for i in  0...assignments.size
                #logger.info("Close date: " + assignments[i].close_date.to_s)
                #logger.info("Current day: " + day.strftime("%Y-%m-%d"))
                if assignments[i].close_date.to_s == day.strftime("%Y-%m-%d")
                  html += "<div class='assignment'>" + assignments[i].name + "</div>"  
                end  
              end
             end 
             
            if quizzes.size > 0 
              for i in 0...quizzes.size
                #logger.info("Quiz date: " + quizzes[i].date.to_s)
                #logger.info("Current day: " + day.strftime("%Y-%m-%d"))
                if quizzes[i].date.to_s == day.strftime("%Y-%m-%d")
                  html += "<div class='quiz'>" + quizzes[i].name + "</div>"
                end
              end  
            end
            
            html += "</td>"            
            
          end
          html += "</tr>\n"
          
        end

        #html +=  "<tr>" + s.join("</tr><tr>") + "</tr>"

      end
    end

    html += "</table>"
<<END
#{html}
END
  end
 
  private

  def _mkcalendar(object, method, show_field = true, popup = true, html_options = {}, calendar_options = {})
    button_image = html_options[:button_image] || 'calendar'
    date = value(object, method)

    input_field_id = "#{object}_#{method}" 
    calendar_id = "#{object}_#{method}_calendar" 

    add_defaults(calendar_options, :ifFormat => '%Y/%m/%d %H:%M:%S')

    field_options = html_options.dup
    add_defaults(field_options,
      :value => date && date.strftime(calendar_options[:ifFormat]),
      :size => 12
    )
    rename_option(field_options, :field_title, :title)
    remove_option(field_options, :button_title)
    if show_field
      field = text_field(object, method, field_options)
    else
      field = hidden_field(object, method, field_options)
    end

    if popup
      button_options = html_options.dup
      add_mandatories(button_options, :id => calendar_id)
      rename_option(button_options, :button_title, :title)
      remove_option(button_options, :field_title)
      calendar = image_tag(button_image, button_options)
    else
      calendar = "<div id=\"#{calendar_id}\" class=\"#{html_options[:class]}\"></div>" 
    end

    calendar_setup = calendar_options.dup
    add_mandatories(calendar_setup,
      :inputField => input_field_id,
      (popup ? :button : :flat) => calendar_id
    )

<<END
#{field}
#{calendar}
<script type="text/javascript">
  Calendar.setup({ #{format_js_hash(calendar_setup)} })
</script>
END
  end

  def value(object_name, method_name)
    if object = self.instance_variable_get("@#{object_name}")
      object.send(method_name)
    else
      nil
    end
  end

  def add_mandatories(options, mandatories)
    options.merge!(mandatories)
  end

  def add_defaults(options, defaults)
    options.merge!(defaults) { |key, old_val, new_val| old_val }
  end

  def remove_option(options, key)
    options.delete(key)
  end

  def rename_option(options, old_key, new_key)
    if options.has_key?(old_key)
      options[new_key] = options.delete(old_key)
    end
    options
  end

  def format_js_hash(options)
    options.collect { |key,value| key.to_s + ':' + value.inspect }.join(',')
  end

end

