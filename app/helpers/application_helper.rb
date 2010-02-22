# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def textilize(text)
      RedCloth.new(text).to_html
  end

  def ajax_pagination_links(paginator, options={})

   options.merge!(ActionView::Helpers::PaginationHelper::DEFAULT_OPTIONS) {|key, old, new| old}

   window_pages = paginator.current.window(options[:window_size]).pages

   logger.info("Window pages: " + window_pages.length.to_s)

   return if window_pages.length <= 1 unless
     options[:link_to_current_page]

   first, last = paginator.first, paginator.last

   returning html = '' do
     if options[:always_show_anchors] and not window_pages[0].first?
       html << link_to_remote(first.number, :update => options[:update], :url => { :controller => options[:controller], :action => options[:action], options[:name] => first }.update(options[:params] ))
       html << ' ... ' if window_pages[0].number - first.number > 1
       html << ' '
     end

     window_pages.each do |page|
       if paginator.current == page && !options[:link_to_current_page]
         html << page.number.to_s
       else
         html << link_to_remote(page.number, :update => options[:update], :url => { :controller => options[:controller], :action => options[:action], options[:name] => page }.update(options[:params] ))
       end
       html << ' '
     end

     if options[:always_show_anchors] && !window_pages.last.last?
       html << ' ... ' if last.number - window_pages[-1].number > 1
       html << link_to_remote(paginator.last.number, :update => options[:update], :url => { :controller => options[:controller], :action => options[:action], options[:name] => last }.update( options[:params]))
     end
   end
  end
  
end
