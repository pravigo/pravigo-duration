require "pravigo/duration/version"
require 'active_support/time'

class BasicObject
  def __realclass__; (class << self; self end).superclass end
end

class Object; alias __realclass__ class end

class Pravigo
  #module Duration


#class Duration < ActiveSupport::Duration
class ActiveSupport::Duration
	
  @@MONTHS_IN_A_YEAR = 12
  @@SECONDS_IN_A_WEEK = 604800
  @@SECONDS_IN_A_DAY = 86400
  @@SECONDS_IN_AN_HOUR = 3600
  @@SECONDS_IN_A_MINUTE = 60
  #Approximate number of seconds in a month and year
  @@SECONDS_IN_A_YEAR = @@SECONDS_IN_A_DAY * 365
  @@SECONDS_IN_A_MONTH = @@SECONDS_IN_A_DAY * 30			
		
  def initialize(*args)
    case args.size
    when 1 
	  if args[0].is_a? ::ActiveSupport::Duration
	    @value = args[0].value
		@parts = args[0].parts
	  else
	    if args[0].is_a? ::String
          iso8601Duration = args[0]
		  iso8601Duration = iso8601Duration.gsub(',','.')
		  
          if /\AP(?:(-?\d+)Y|Y)?
              (?:(-?\d+)M|M)?
	          (?:(-?\d+)D|D)?
	          (?:T(?:(-?\d+)H|H)?
	              (?:(-?\d+)M|M)?
	              (?:(-?\d+(?:(\.|\,)\d{1,4})?)S|S)?
	          )?
	          \Z/ix =~iso8601Duration
	 
            @years = $1.to_i
		    @months = $2.to_i
            @days = $3.to_i
            @hours = $4.to_i
            @minutes = $5.to_i
		    @seconds = $6.to_f
          
          else		  
		    if /\A(?:(\d+):?)?
			      (?:(\d+):?)?
				  (\d+)?
	              \Z/ix =~iso8601Duration
			
			  @years = 0
		      @months = 0
              @days = 0
			  @hours = $1.to_i
              @minutes = $2.to_i
		      @seconds = $3.to_f
			else
			  return ::NilClass
			  @years = 0
		      @months = 0
              @days = 0
			  @hours = 0
              @minutes = 0
		      @seconds = 0
			end
	      end
			
		    @value = (@years*@@SECONDS_IN_A_YEAR)+
	                 (@months*@@SECONDS_IN_A_MONTH)+
		    	     (@days*@@SECONDS_IN_A_DAY)+
			         (@hours*@@SECONDS_IN_AN_HOUR)+
			         (@minutes*@@SECONDS_IN_A_MINUTE)+
			         (@seconds)
            @parts = []
		  
		    @parts << [:years, @years] if @years!=0
	        @parts << [:months, @months] if @months!=0
		    @parts << [:days, @days] if @days!=0
	  	    @parts << [:hours, @hours] if @hours !=0
		    @parts << [:minutes, @minutes] if @minutes !=0
		    @parts << [:seconds,@seconds] if @seconds!=0
	      
		    #else raise an error
		  else if args[0].is_a? ::Numeric
		    @value = args[0]
			days_c = @value.divmod(@@SECONDS_IN_A_DAY)
			hours_c = days_c[1].divmod(@@SECONDS_IN_AN_HOUR)
            minutes_c = hours_c[1].divmod(@@SECONDS_IN_A_MINUTE)
            seconds_c = minutes_c[1]
			@parts = []		  
		    @parts << [:days, days_c[0]] if days_c[0]>0
	  	    @parts << [:hours, hours_c[0]] if hours_c[0] >0
		    @parts << [:minutes, minutes_c[0]] if minutes_c[0] >0
		    @parts << [:seconds,seconds_c] if seconds_c >0
  
	      end
	    end
	  end
    when 2
      @value = args[0]
	  @parts = args[1]
    end
  end

  def iso8601
    grouped_parts = parts.group_by(&:first).map { |k, v| [k, v.map(&:last).inject(:+)] }
    hash_of_parts = ::Hash[grouped_parts]
    hash_of_parts.default = 0

    total_months = (hash_of_parts[:years]*@@MONTHS_IN_A_YEAR)+(hash_of_parts[:months])
    totalSeconds = (hash_of_parts[:days]*@@SECONDS_IN_A_DAY)+(hash_of_parts[:hours]*@@SECONDS_IN_AN_HOUR)+(hash_of_parts[:minutes]*@@SECONDS_IN_A_MINUTE)+(hash_of_parts[:seconds])
    if (total_months < 0)
	  negative_months = "-"
	  total_months = 0-total_months
	else
	  negative_months = ""
	end
	if (totalSeconds < 0)
	  negative_seconds = "-"
	  totalSeconds = 0-totalSeconds
	else
	  negative_seconds=""
	end
  
    years_c = total_months.divmod(@@MONTHS_IN_A_YEAR)
    days_c = totalSeconds.divmod(@@SECONDS_IN_A_DAY)
    hours_c = days_c[1].divmod(@@SECONDS_IN_AN_HOUR)
    minutes_c = hours_c[1].divmod(@@SECONDS_IN_A_MINUTE)
    seconds_c = minutes_c[1]
  
    result = "P"
	result << (years_c[0] != 0 ? "#{negative_months}#{years_c[0]}Y" : "")
    result << (years_c[1] != 0 ? "#{negative_months}#{years_c[1]}M" :  "")
    result << (days_c[0] != 0  ? "#{negative_months}#{days_c[0]}D" : "")
  
    result << (days_c[1] != 0 ? "T" : "")
	result << (hours_c[0] != 0 ? "#{negative_seconds}#{hours_c[0]}H" : "")
    result << (minutes_c[0] != 0 ?  "#{negative_seconds}#{minutes_c[0]}M" : "")
   # result << (seconds_c > 0 ? "#{seconds_c}S" : "")
    result << (seconds_c != 0 ? ((seconds_c % 1 ==0) ?  "#{negative_seconds}#{seconds_c.to_i}S" : "#{negative_seconds}#{seconds_c.round(4)}S") : "")
	
  end

  ##need to DRY this out
  def as_24h_clock
    grouped_parts = parts.group_by(&:first).map { |k, v| [k, v.map(&:last).inject(:+)] }
    hash_of_parts = ::Hash[grouped_parts]
    hash_of_parts.default = 0

    total_months = (hash_of_parts[:years]*@@MONTHS_IN_A_YEAR)+(hash_of_parts[:months])
    totalSeconds = (hash_of_parts[:days]*@@SECONDS_IN_A_DAY)+(hash_of_parts[:hours]*@@SECONDS_IN_AN_HOUR)+(hash_of_parts[:minutes]*@@SECONDS_IN_A_MINUTE)+(hash_of_parts[:seconds])
    if (total_months < 0)
	  negative_months = "-"
	  total_months = 0-total_months
	else
	  negative_months = ""
	end
	if (totalSeconds < 0)
	  negative_seconds = "-"
	  totalSeconds = 0-totalSeconds
	else
	  negative_seconds=""
	end
  
    years_c = total_months.divmod(@@MONTHS_IN_A_YEAR)
    days_c = totalSeconds.divmod(@@SECONDS_IN_A_DAY)
    hours_c = days_c[1].divmod(@@SECONDS_IN_AN_HOUR)
    minutes_c = hours_c[1].divmod(@@SECONDS_IN_A_MINUTE)
    seconds_c = minutes_c[1]
  
    result = ""
  
	result << (hours_c[0] != 0 ? "#{negative_seconds}#{ "%02d" % hours_c[0]}:" : "00:")
    result << (minutes_c[0] != 0 ?  "#{negative_seconds}#{ "%02d" %  minutes_c[0]}:" : "00:")
    result << (seconds_c != 0 ? ((seconds_c % 1 ==0) ?  "#{negative_seconds}#{ "%02d" % seconds_c.to_i}" : "#{negative_seconds}#{seconds_c.round(4)}") : "00")
	result << (years_c[0] != 0 ? "+ #{negative_months}#{years_c[0]} years" : "")
    result << (years_c[1] != 0 ? "+ #{negative_months}#{years_c[1]} months":  "")
 	result << (days_c[0] != 0  ? "+ #{negative_months}#{days_c[0]} days" : "")
 
  end
  
  #include :hours in inspect
  def inspect #:nodoc:
      consolidated = parts.inject(::Hash.new(0)) { |h,(l,r)| h[l] += r; h }
      parts = [:years, :months, :days, :hours, :minutes, :seconds].map do |length|
        n = consolidated[length]
        "#{n} #{n == 1 ? length.to_s.singularize : length.to_s}" if n.nonzero?
      end.compact
      parts = ["0 seconds"] if parts.empty?
      parts.to_sentence(:locale => :en)
  end

 # Adds another Duration or a Numeric to this Duration. Numeric values
    # are treated as seconds.
    def +(other)
      if ::Duration === other
        ::Duration.new(value + other.value, @parts + other.parts)
      else
	    if ::Time === other
		  other + self
	    else
          ::Duration.new(value + other, @parts + [[:seconds, other]])
		end
      end
    end

    # Subtracts another Duration or a Numeric from this Duration. Numeric
    # values are treated as seconds.
    def -(other)
      if ::Duration === other
	     
         ::Duration.new(value - other.value, @parts +( other.parts.dup.map! { |k,v| [k,-v] } ))
      else
	    if ::Time === other
		  # minus operator is not canonical
	    else
          ::Duration.new(value - other, @parts + [[:seconds, -other]])
		end
      end
    end

  end
end

Duration = ActiveSupport::Duration
d= (Duration.new("PT0S")+Duration.new("PT3M"))
puts d.as_24h_clock
