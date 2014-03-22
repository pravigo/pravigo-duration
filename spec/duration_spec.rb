# duration_spec.rb
require "spec_helper"
#require 'active_support/time'
#require File.expand_path(File.dirname(__FILE__) + '/duration')

describe Duration do

  MONTHS_IN_A_YEAR = 12
  SECONDS_IN_A_WEEK=604800
  SECONDS_IN_A_DAY=86400
  SECONDS_IN_AN_HOUR=3600
  SECONDS_IN_A_MINUTE=60
  #Approximate number of seconds in a month and year
  SECONDS_IN_A_YEAR=(SECONDS_IN_A_DAY*365)
  SECONDS_IN_A_MONTH=(SECONDS_IN_A_DAY * 30)	

  let(:duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string) { Duration.new('PT5m30s') }
  let(:duration_of_4_minutes_initialised_by_value_and_parts) { Duration.new(240,[[:minutes, 4]]) }
  let(:duration_of_4_minutes_initialised_by_numeric) { Duration.new(240) }
  let(:activeSupport_Duration_of_4_minutes) { ActiveSupport::Duration.new(240,[[:minutes, 4]]) }
  let(:activeSupport_Duration_of_5_minutes) { ActiveSupport::Duration.new(300,[[:minutes, 5]]) } 
  let(:activeSupport_Duration_of_1_year_3_months_and_3_hours) { ActiveSupport::Duration.new((SECONDS_IN_A_YEAR+(SECONDS_IN_A_MONTH*3)+(SECONDS_IN_AN_HOUR*3)),[[:years, 1],[:months,3],[:hours,3]]) } 
  let(:duration_of_5_minutes_initialised_by_ActiveSupport_Duration) { Duration.new(activeSupport_Duration_of_5_minutes) }
  let(:time_2014_02_28_1558_28) { Time.new(2014, 02, 28, 15, 58, 28) }
  let(:duration_of_1_year_5_months_and_3_hours) { Duration.new('P1y5mT3h') }
  let(:invalid_Duration_missing_T) { Duration.new('P5m30s') }
  
 #seconds as a float 
  let(:y____s_float) { Duration.new('P1YT1.234S')}
  let(:ym___s_float) { Duration.new('P1Y1MT1.234S')}
  let(:ymd__s_float) { Duration.new('P1Y1M1DT1.234S')}
  let(:ymdh_s_float) { Duration.new('P1Y1M1DT1H1.234S')}
  let(:ymdhms_float) { Duration.new('P1Y1M1DT1H1M1.234S')}
  let(:_m___s_float) { Duration.new('P1MT1.234S')}
  let(:_md__s_float) { Duration.new('P1M1DT1.234S')}
  let(:_mdh_s_float) { Duration.new('P1M1DT1H1.234S')}
  let(:_mdhms_float) { Duration.new('P1M1DT1H1M1.234S')}  
  let(:__d__s_float) { Duration.new('P1DT1.234S')}  
  let(:__dh_s_float) { Duration.new('P1DT1H1.234S')}
  let(:__dhms_float) { Duration.new('P1DT1H1M1.234S')}  
  let(:___h_s_float) { Duration.new('PT1H1.234S')}
  let(:___hms_float) { Duration.new('PT1H1M1.234S')} 
  let(:____ms_float) { Duration.new('PT1M1.234S')}
  let(:_____s_float) { Duration.new('PT1.234S')}
  
  describe '.initialise' do
   
    context 'given valid iso8601 string' do
	
      it 'creates an instance of Duration' do
		duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string.__realclass__.should eq(Duration)
	  end
	
      it 'creates a new parts array' do
	    duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string.parts.should eq([[:minutes,5],[:seconds,30.0]])
		
      end
	
	  it 'creates a new value' do
	     duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string.value.should eq(330.0) 
      end
	
      it 'outputs a valid iso8601 representation' do
	    duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string.iso8601.should eq('PT5M30S')
	  end	
	  
	  it 'creates a subclass of ActiveSupport::Duration' do
        (duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string.is_a? ActiveSupport::Duration).should eq(true)
      end
	
    end
		
	context 'given an invalid iso8601 string' do
	
	  it 'returns a NilClass' do
	    expect(invalid_Duration_missing_T).to be_a NilClass
	  end
	
	end
	
	context 'given a value and parts array' do
	
	  it 'creates an instance of Duration' do
		duration_of_4_minutes_initialised_by_value_and_parts.__realclass__.should eq(Duration)
	  end
	
	  it 'creates a new parts array' do
        duration_of_4_minutes_initialised_by_value_and_parts.parts.should eq([[:minutes,4]])  
      end
	
	  it 'creates a new value' do
	    duration_of_4_minutes_initialised_by_value_and_parts.value.should eq(240)
      end
	  
	  it 'outputs a valid iso8601 representation' do
	    duration_of_4_minutes_initialised_by_value_and_parts.iso8601.should eq('PT4M')
	  end
	
	  it 'creates a subclass of ActiveSupport::Duration' do
        (duration_of_4_minutes_initialised_by_value_and_parts.is_a? ActiveSupport::Duration).should eq(true)
      end
	  
	  it 'creates a Duration equal to ActiveSupport::Duration initialised the same way' do
        duration_of_4_minutes_initialised_by_value_and_parts.should eq(activeSupport_Duration_of_4_minutes)
      end
	
	end

	context 'given a numeric' do
	
	  it 'creates an instance of Duration' do
		duration_of_4_minutes_initialised_by_numeric.__realclass__.should eq(Duration)
	  end
	
	  it 'assumes the numeric to be seconds and creates a new parts array' do
        duration_of_4_minutes_initialised_by_numeric.parts.should eq([[:minutes,4]])  
      end
	
	  it 'assumes the numeric to be seconds and creates a new value' do
	    duration_of_4_minutes_initialised_by_numeric.value.should eq(240)
      end
	  
	  it 'outputs a valid iso8601 representation' do
	    duration_of_4_minutes_initialised_by_numeric.iso8601.should eq('PT4M')
	  end
	
	  it 'creates a subclass of ActiveSupport::Duration' do
        (duration_of_4_minutes_initialised_by_numeric.is_a? ActiveSupport::Duration).should eq(true)
      end
	  
	end
	
	context 'given an ActiveSupport::Duration' do
	
      it 'creates an instance of Duration' do
		duration_of_5_minutes_initialised_by_ActiveSupport_Duration.__realclass__.should eq(Duration)
	  end
	
      it 'creates a new parts array' do
	    duration_of_5_minutes_initialised_by_ActiveSupport_Duration.parts.should eq([[:minutes,5]])
      end
	
	  it 'creates a new value' do
	     duration_of_5_minutes_initialised_by_ActiveSupport_Duration.value.should eq(300.0) 
      end
	
      it 'outputs a valid iso8601 representation' do
	    duration_of_5_minutes_initialised_by_ActiveSupport_Duration.iso8601.should eq('PT5M')
	  end	
	  
	  it 'creates a subclass of ActiveSupport::Duration' do
        (duration_of_5_minutes_initialised_by_ActiveSupport_Duration.is_a? ActiveSupport::Duration).should eq(true)
      end
	  
	  it 'creates a Duration equal to ActiveSupport::Duration initialised the same way' do
        duration_of_5_minutes_initialised_by_ActiveSupport_Duration.should eq(activeSupport_Duration_of_5_minutes)
      end
	
    end
	
  end    

  describe "iso8604 testing" do
    {"P1Y"            => [[[:years,1]],(SECONDS_IN_A_DAY*365),"P1Y"],
	 "P1Y1M"          => [[[:years,1],[:months,1]],(SECONDS_IN_A_DAY*365)+SECONDS_IN_A_MONTH, "P1Y1M"],
	 "P1YT1H"         => [[[:years,1],[:hours,1]], (SECONDS_IN_A_DAY*365)+SECONDS_IN_AN_HOUR, "P1YT1H"],
	 "P1YT1M"         => [[[:years,1],[:minutes,1]],(SECONDS_IN_A_DAY*365)+60,"P1YT1M"],
	 "P1YT1S"         => [[[:years,1],[:seconds,1.0]],(SECONDS_IN_A_DAY*365)+1,"P1YT1S"],
	 "P1Y1M1D"        => [[[:years,1],[:months,1],[:days,1]],(SECONDS_IN_A_DAY*365)+(SECONDS_IN_A_DAY*31),"P1Y1M1D"],
	 "P1Y1MT1H"       => [[[:years,1],[:months,1],[:hours,1]],(SECONDS_IN_A_DAY*365)+(SECONDS_IN_A_DAY*30)+SECONDS_IN_AN_HOUR,"P1Y1MT1H"],
	 "P1Y1MT1M"       => [[[:years,1],[:months,1],[:minutes,1]],(SECONDS_IN_A_DAY*365)+(SECONDS_IN_A_DAY*30)+60,"P1Y1MT1M"  ], 
	 "P1Y1MT1S"       => [[[:years,1],[:months,1],[:seconds,1.0]],(SECONDS_IN_A_DAY*365)+(SECONDS_IN_A_DAY*30)+1 ,"P1Y1MT1S"],
	 "P1Y1M1DT1H"     => [[[:years,1],[:months,1],[:days,1],[:hours,1]],(SECONDS_IN_A_DAY*365)+(SECONDS_IN_A_DAY*31)+SECONDS_IN_AN_HOUR,"P1Y1M1DT1H"],
	 "P1Y1M1DT1M"     => [[[:years,1],[:months,1],[:days,1],[:minutes,1]],(SECONDS_IN_A_DAY*365)+(SECONDS_IN_A_DAY*31)+60,"P1Y1M1DT1M"],
	 "P1Y1M1DT1S"     => [[[:years,1],[:months,1],[:days,1],[:seconds,1.0]],(SECONDS_IN_A_DAY*365)+(SECONDS_IN_A_DAY*31)+1,"P1Y1M1DT1S"],
	 "P1Y1M1DT1H1M"   => [[[:years,1],[:months,1],[:days,1],[:hours,1],[:minutes,1]],(SECONDS_IN_A_DAY*365)+(SECONDS_IN_A_DAY*31)+SECONDS_IN_AN_HOUR+60,"P1Y1M1DT1H1M"],
	 "P1Y1M1DT1H1S"   => [[[:years,1],[:months,1],[:days,1],[:hours,1],[:seconds,1.0]],(SECONDS_IN_A_DAY*365)+(SECONDS_IN_A_DAY*31)+SECONDS_IN_AN_HOUR+1,"P1Y1M1DT1H1S"],
	 "P1Y1M1DT1H1M1S" => [[[:years,1],[:months,1],[:days,1],[:hours,1],[:minutes,1],[:seconds,1.0]],(SECONDS_IN_A_DAY*365)+(SECONDS_IN_A_DAY*31)+SECONDS_IN_AN_HOUR+61,"P1Y1M1DT1H1M1S"],
	 "P1M"            => [[[:months,1]],(SECONDS_IN_A_DAY*30),"P1M"],
	 "P1M1D"          => [[[:months,1],[:days,1]],(SECONDS_IN_A_DAY*31),"P1M1D"], 
	 "P1MT1H"         => [[[:months,1],[:hours,1]],(SECONDS_IN_A_DAY*30)+SECONDS_IN_AN_HOUR,"P1MT1H"], 
	 "P1MT1M"         => [[[:months,1],[:minutes,1]],(SECONDS_IN_A_DAY*30)+60,"P1MT1M"], 
	 "P1MT1S"         => [[[:months,1],[:seconds,1.0]],(SECONDS_IN_A_DAY*30)+1,"P1MT1S"], 
	 "P1M1DT1H"       => [[[:months,1],[:days,1],[:hours,1]],(SECONDS_IN_A_DAY*31)+SECONDS_IN_AN_HOUR,"P1M1DT1H"], 
	 "P1M1DT1M"       => [[[:months,1],[:days,1],[:minutes,1]],(SECONDS_IN_A_DAY*31)+60,"P1M1DT1M"], 
	 "P1M1DT1S"       => [[[:months,1],[:days,1],[:seconds,1.0]],(SECONDS_IN_A_DAY*31)+1,"P1M1DT1S"], 
 	 "P1M1DT1H1M"     => [[[:months,1],[:days,1],[:hours,1],[:minutes,1]],(SECONDS_IN_A_DAY*31)+SECONDS_IN_AN_HOUR+60,"P1M1DT1H1M"],
 	 "P1M1DT1H1S"     => [[[:months,1],[:days,1],[:hours,1],[:seconds,1.0]],(SECONDS_IN_A_DAY*31)+SECONDS_IN_AN_HOUR+1,"P1M1DT1H1S"], 
	 "P1M1DT1H1M1S"   => [[[:months,1],[:days,1],[:hours,1],[:minutes,1],[:seconds,1.0]],(SECONDS_IN_A_DAY*31)+SECONDS_IN_AN_HOUR+61,"P1M1DT1H1M1S"], 
	 "P1D"            => [[[:days,1]],SECONDS_IN_A_DAY,"P1D"],
	 "P1DT1H"         => [[[:days,1],[:hours,1]],SECONDS_IN_A_DAY+SECONDS_IN_AN_HOUR,"P1DT1H"],
	 "P1DT1M"         => [[[:days,1],[:minutes,1]],SECONDS_IN_A_DAY+60,"P1DT1M"],
	 "P1DT1S"         => [[[:days,1],[:seconds,1.0]],SECONDS_IN_A_DAY+1,"P1DT1S"],
	 "P1DT1H1M"       => [[[:days,1],[:hours,1],[:minutes,1]],SECONDS_IN_A_DAY+SECONDS_IN_AN_HOUR+60,"P1DT1H1M"],
	 "P1DT1H1S"       => [[[:days,1],[:hours,1],[:seconds,1.0]],SECONDS_IN_A_DAY+SECONDS_IN_AN_HOUR+1,"P1DT1H1S"],
	 "P1DT1H1M1S"     => [[[:days,1],[:hours,1],[:minutes,1],[:seconds,1.0]],SECONDS_IN_A_DAY+SECONDS_IN_AN_HOUR+61,"P1DT1H1M1S"],
	 "PT1H"           => [[[:hours,1]],SECONDS_IN_AN_HOUR,"PT1H"],
 	 "PT1H1M"         => [[[:hours,1],[:minutes,1]],SECONDS_IN_AN_HOUR+60,"PT1H1M"],
 	 "PT1H1S"         => [[[:hours,1],[:seconds,1.0]],SECONDS_IN_AN_HOUR+1,"PT1H1S"],
	 "PT1H1M1S"       => [[[:hours,1],[:minutes,1],[:seconds,1.0]],SECONDS_IN_AN_HOUR+61,"PT1H1M1S"],
	 "PT1M"           => [[[:minutes,1]],60,"PT1M"],
 	 "PT1M1S"         => [[[:minutes,1],[:seconds,1.0]],61,"PT1M1S"],
 	 "PT1S"           => [[[:seconds,1.0]],1,"PT1S"],
	 "PT1.2345S"      => [[[:seconds,1.2345]],1.2345,"PT1.2345S"],
	 "PT1.234S"       => [[[:seconds,1.234]],1.234,"PT1.234S"],
	 "PT1.23S"        => [[[:seconds,1.23]],1.23,"PT1.23S"],
	 "PT1.2S"         => [[[:seconds,1.2]],1.2,"PT1.2S"],
 	 "PT1,2345S"      => [[[:seconds,1.2345]],1.2345,"PT1.2345S"],
	 "PT1,234S"       => [[[:seconds,1.234]],1.234,"PT1.234S"],
	 "PT1,23S"        => [[[:seconds,1.23]],1.23,"PT1.23S"],
	 "PT1,2S"         => [[[:seconds,1.2]],1.2,"PT1.2S"]

	 }.each do |input, output|
	  durationToTest = Duration.new(input)
	  context "given a valid iso8601 duration string: #{input}, the initialised Duration" do
	  
	    it "has parts = #{output[0].to_s}" do
	        durationToTest.parts.should eq(output[0])
	    end

  	    it "has value = #{output[1].to_s} seconds" do
		    durationToTest.value.should eq(output[1])
        end
		
        it "returns #{output[2]} as iso8601" do
	  	  durationToTest.iso8601.should eq(output[2])
  	    end
	  end
    end
  end

  describe '#+ (add)' do
     context 'given a Time' do
	 
  	   it 'returns a time' do
         (duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string+time_2014_02_28_1558_28).should be_an_instance_of Time
       end
	   
	   it 'increases the Time by the Duration' do
         (duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string+time_2014_02_28_1558_28).should eq(Time.new(2014, 02, 28, 16, 03, 58))
       end
	   
     end
  

     context 'given a Duration' do
	   
	   it 'returns a Duration' do
         (duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string+duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string).__realclass__.should eq(Duration)
       end
	   
	   it 'returns the sum of the two Durations' do
         (duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string+duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string).should eq(Duration.new('PT11m'))
       end
	 
     end
  
     context 'given an ActiveSupport::Duration' do
	   it 'returns a Duration' do
         (duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string+activeSupport_Duration_of_4_minutes).__realclass__.should eq(Duration)
       end
	   
	   it 'returns the sum of the two Durations' do
         (duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string+activeSupport_Duration_of_4_minutes).should eq(Duration.new('PT9m30s'))
       end
     end 
  
    context 'given a Numeric' do
  	  it 'returns a Duration' do
	    expect((duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string+30).__realclass__).to eq(Duration)
	  end
	  
	  it 'assumes the Numeric is seconds and adds to the Duration' do
	    expect(duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string+30).to eq(360)
	  end
	  
    end
  
  end

  describe '#- (subtract)' do
    
    context 'given a Duration' do
	   
      it 'returns a Duration' do
        (duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string-duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string).__realclass__.should eq(Duration)
      end
	   
	  it 'returns the Duration minus the second duration' do
        (duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string-duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string).should eq(Duration.new('P'))
      end
	   
	  it 'returns the Duration minus the second duration' do
        (duration_of_4_minutes_initialised_by_value_and_parts-duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string).should eq(Duration.new('PT-1M-30S'))
      end
	 
     end

   end
  
  describe '#iso80601' do
  
  let(:duration_with_15_months) { Duration.new('P15M') } 
  let(:duration_with_75_seconds) { Duration.new('PT75S') } 
  let(:duration_with_70_minutes) { Duration.new('PT70M') } 
  let(:duration_with_27_hours) { Duration.new('PT27H') } 
  let(:duration_with_9_days) { Duration.new('P9D') } 
  let(:duration_with_2_months_and_45_days) { Duration.new('P2M45D') } 
  let(:duration_with_second_to_6_decimal_places) { Duration.new(1.234567,[[:seconds,1.234567]]) } 
  

	it 'returns iso8601 representation in years and months when months is 12 or over' do
         duration_with_15_months.iso8601.should eq('P1Y3M')
		 
    end
	
	it 'returns iso8601 representation in minutes and seconds when seconds is 60 or over' do
         duration_with_75_seconds.iso8601.should eq('PT1M15S')
    end
	
	it 'returns iso8601 representation in hours and minutes when minutes is 60 or over' do
         duration_with_70_minutes.iso8601.should eq('PT1H10M')
    end
	
    it 'returns iso8601 representation in days and hours when hours is 24 or over' do
         duration_with_27_hours.iso8601.should eq('P1DT3H')
    end
	
	it 'returns iso8601 representation in days when number of days exceeds 7 (weeks are ignored)' do
         duration_with_9_days.iso8601.should eq('P9D')
    end
	
    it 'returns iso8601 representation in days when days clearly exceeds number of possible days in a month' do
         duration_with_2_months_and_45_days.iso8601.should eq('P2M45D')
    end
	
    it 'returns iso8601 representation with seconds rounded to 4 decimal places' do
   		duration_with_second_to_6_decimal_places.iso8601.should eq('PT1.2346S')
	end
	
  end
  
  describe 'Test adding a Duration to an ActiveSupport::Duration' do
    it 'returns an ActiveSupport:Duration' do
	  (activeSupport_Duration_of_4_minutes + duration_of_4_minutes_initialised_by_value_and_parts).__realclass__.should eq(ActiveSupport::Duration)
    end
	
    it 'returns the sum of the two durations' do
      expect(activeSupport_Duration_of_4_minutes + duration_of_4_minutes_initialised_by_value_and_parts).to eq(ActiveSupport::Duration.new(480,[[:minutes,4],[:minutes,4]]))
    end

   it 'confirms ActiveSupport::Duration behaviour combines parts when matching i.e. [[:minutes,4],[:minutes,4]] is equal to [[:minutes,8]]' do
      expect(activeSupport_Duration_of_4_minutes + duration_of_4_minutes_initialised_by_value_and_parts).to eq(ActiveSupport::Duration.new(480,[[:minutes,8]]))
   end

   it 'preserves months and years (does not convert to seconds)' do
	  expect(Duration.new(activeSupport_Duration_of_1_year_3_months_and_3_hours+duration_of_1_year_5_months_and_3_hours).iso8601).to eq("P2Y8MT6H")
   end
	
  end
  
  describe 'Test adding a Duration to a Time' do
  
    it 'returns a time' do
      (time_2014_02_28_1558_28+duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string).should be_an_instance_of Time
    end
	   
	it 'increases the Time by the Duration' do
      (time_2014_02_28_1558_28+duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string).should eq(Time.new(2014, 02, 28, 16, 03, 58))
    end
	   
    it 'correctly handles months and years (does not convert to seconds)' do
      (time_2014_02_28_1558_28+duration_of_1_year_5_months_and_3_hours).should eq(Time.new(2015, 07, 28, 18, 58, 28))
    end
	
  end
  
 describe 'Test adding a Duration to a Numeric' do
    it 'returns a Numeric' do
      expect((100+duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string).is_a? Numeric).to eq(true)
    end
	
    it 'returns the Numeric plus the Duration in seconds' do
      (100+duration_of_5_minutes_and_30_seconds_initialised_from_iso8601_string).should eq(430)
	end
	
	it 'assumes a year is 365 days and a month is 30 days' do
	  expect(100+duration_of_1_year_5_months_and_3_hours).to eq(SECONDS_IN_A_YEAR+(SECONDS_IN_A_MONTH*5)+(SECONDS_IN_AN_HOUR*3)+100)      
	end
	
  end
  
end