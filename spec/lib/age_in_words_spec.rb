require 'spec_helper'

describe "Age In Words" do
  context 'should require a Date or a Time or a convertible string' do
    it 'should permit a Date' do
      dob = Chronic.parse("50 months ago").to_date
      dob.class.should == Date
      AgeInWords::get_age_in_words(dob).should_not == AgeInWords::ERROR_TEXT
    end
    it 'should permit a Time' do
      dob = Chronic.parse("50 months ago").to_time
      dob.class.should == Time
      AgeInWords::get_age_in_words(dob).should_not == AgeInWords::ERROR_TEXT
    end
    it 'should permit a valid date string' do
      dob = Chronic.parse("50 months ago").strftime("%D")
      dob.class.should == String
      AgeInWords::get_age_in_words(dob).should_not == AgeInWords::ERROR_TEXT
    end
    it 'should permit a valid date/time string' do
      dob = Chronic.parse("50 months ago").to_s
      dob.class.should == String
      AgeInWords::get_age_in_words(dob).should_not == AgeInWords::ERROR_TEXT
    end
  end

  context 'try various cases for age' do
    it "should work for almost 11 year olds" do
      age = {:years => 10, :months => 9, :days => 6, :text => "10 Yrs, 9 Months, 6 Days"}
      dob = (Chronic.parse("#{12*age[:years] + age[:months]} months ago") - age[:days]*24*60*60).to_date
      AgeInWords::get_age_in_words(dob).should == age[:text]
    end

    it "should work with just years" do
      age = {:years => 10, :months => 0, :days => 0, :text => "10 Yrs"}
      dob = (Chronic.parse("#{12*age[:years] + age[:months]} months ago") - age[:days]*24*60*60).to_date
      AgeInWords::get_age_in_words(dob).should == age[:text]
    end

    it "should work with just months" do
      age = {:years => 0, :months => 10, :days => 0, :text => "10 Months"}
      dob = (Chronic.parse("#{12*age[:years] + age[:months]} months ago") - age[:days]*24*60*60).to_date
      AgeInWords::get_age_in_words(dob).should == age[:text]
    end

    it "should work with just days" do
      age = {:years => 0, :months => 0, :days => 10, :text => "10 Days"}
      dob = (Chronic.parse("#{12*age[:years] + age[:months]} months ago") - age[:days]*24*60*60).to_date
      AgeInWords::get_age_in_words(dob).should == age[:text]
    end

    it "should work with just large value of days" do
      age = {:years => 0, :months => 0, :days => 100, :text => /\d+ Months, \d+ Days/ }
      dob = (Chronic.parse("#{12*age[:years] + age[:months]} months ago") - age[:days]*24*60*60).to_date
      AgeInWords::get_age_in_words(dob).should =~ age[:text]
    end

    it 'should handle an assortment 1' do
      age = {:years => 20, :months => 2, :days => 26, :text => /20 Yrs, 2 Months, 26 Days/ }
      dob = (Chronic.parse("#{12*age[:years] + age[:months]} months ago") - age[:days]*24*60*60).to_date
      AgeInWords::get_age_in_words(dob).should =~ age[:text]
    end
    it 'should handle an assortment 2' do
      age = {:years => 75, :months => 0, :days => 22, :text => /75 Yrs, 0 Months, 22 Days/ }
      dob = (Chronic.parse("#{12*age[:years] + age[:months]} months ago") - age[:days]*24*60*60).to_date
      AgeInWords::get_age_in_words(dob).should =~ age[:text]
    end
    it 'should handle an assortment 3' do
      age = {:years => 0, :months => 0, :days => 0, :text => /< 1 Day/ }
      dob = (Chronic.parse("#{12*age[:years] + age[:months]} months ago") - age[:days]*24*60*60).to_date
      AgeInWords::get_age_in_words(dob).should =~ age[:text]
    end

  end
end