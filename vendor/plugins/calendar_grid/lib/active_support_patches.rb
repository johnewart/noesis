module ActiveSupport
  module CoreExtensions
    module Time
      module Calculations

        class << self
          
          # Time#months_since is broken until Rails changset 1308
          def months_since_year_wrapping_works?
            begin
              ::Time.local(2005,12,31).months_since(12)
            rescue ArgumentError
              return false
            end
            true
          end
          
          # if the usec problem exists, it should be obvious within 10 attempts
          def beginning_of_day_usec_works?
            for i in 1..10
              return false if ::Time.now.beginning_of_day != ::Time.now.beginning_of_day
            end
            true
          end
          
        end
        
        # Time#beginning_of_day may have a non-zero usec before Rails changeset 1959
        # http://dev.rubyonrails.org/changeset/1959
        unless self.beginning_of_day_usec_works?
          def beginning_of_day
            (self - self.seconds_since_midnight).change(:usec => 0)
          end
        end
        
      end
    end
  end
end
    
