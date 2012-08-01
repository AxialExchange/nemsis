require 'chronic'

module AgeInWords

  YEAR_UNIT  = "Year"
  MONTH_UNIT = "Month"
  WEEK_UNIT  = "Week"
  DAY_UNIT   = "Day"

  #
  # == Introduction
  #
  # Age In Words is used to provide a more common vernacular for describing a person's
  # age -- especially useful in a healthcare setting.
  #
  # == The Language of Age
  #
  # The current logic will report on a user's age as follows
  #  * In days for patients less than 30 days,
  #  * In weeks from 4-12 weeks,
  #  * In months from 4-23 months, and then
  #  * In years at > 24 months
  #
  # NOTE: This is approximate... don't get all fussy about leap months/years/etc.
  #
  # == Design Comment
  #
  # Should we need to customize this on a per-client basis, we could probably YML-ize the
  # demarcation for when/how to report age (it is basically "Use X units when age is between min & max").
  #
  # We could also do it as a mixin for classes that implement "dob" method...
  #
  # The Date of Birth +dob+ is required.
  # Error is raised if the dob is not a date/time class.
  #

  ##
  # These are some thresholds (in number of days) for determining how to report back the age.
  DAY_MAX_DAYS    = 30
  WEEK_MAX_DAYS   = 12 * 7
  MONTH_MAX_DAYS  = 365 * 2
  ERROR_TEXT = "Missing DOB"

  def get_age_in_words(dob, to_date = Date.today)
    age_text = ERROR_TEXT
    return age_text if dob.nil? || (!dob.respond_to?("to_date") && !dob.kind_of?(String))

    from_date = convert_to_date(dob)
    to_date = convert_to_date(to_date)

    age_in_days = (from_date - to_date).abs.to_i
    modulus = 0

    if age_in_days <= DAY_MAX_DAYS
      age = age_in_days
      text = display_age_and_units(age, DAY_UNIT)
    elsif age_in_days <= WEEK_MAX_DAYS
      age,modulus = age_in_days.divmod(7)
      text = display_age_and_units(age, WEEK_UNIT)
    elsif age_in_days <= MONTH_MAX_DAYS
      age,modulus = age_in_days.divmod(30)
      text = display_age_and_units(age, MONTH_UNIT)
    else
      age,modulus = age_in_days.divmod(365)
      text = display_age_and_units(age, YEAR_UNIT)
    end

    #puts "#{age_in_days} days => #{text} / #{modulus}|"

    text
  end

  def convert_to_date(date)
    if date.kind_of?(String)
      date = Chronic.parse(date)
    end
    date = date.to_date
  end

  def get_verbose_age_in_words dob
    age_text = ERROR_TEXT
    return age_text if dob.nil? || (!dob.respond_to?("to_date") && !dob.kind_of?(String))

    if dob.kind_of?(String)
      dob = Chronic.parse(dob)
    end

    dob = dob.to_date

    from_date = dob
    to_date = Date.today
    hash = DateHash.new((from_date - to_date).abs.to_i, from_date, to_date, {}).to_hash
    age_text = verbose_date_in_words(hash)
  end

  private
  def display_age_and_units(age, units)
    text = "#{age} #{units}#{age == 1 ? '' : 's'}"
  end

  ##
  # Display age like '10 Yrs, 9 Months, 6 Days'
  def verbose_date_in_words(hash, options = {})

    return '< 1 Day' if hash.empty?

    date_measurements = Hash.new
    date_measurements[:years]  = YEAR_UNIT
    date_measurements[:months] = MONTH_UNIT
    date_measurements[:days]   = DAY_UNIT

    # Remove all the values that are nil or excluded. Keep the required ones.
    date_measurements.delete_if do |measure, key|
      hash[key].nil? || options[:zero] && !options[:zero] && hash[key].zero? || (!options[:except].nil? && options[:except].include?(key)) ||
          (options[:only] && !options[:only].include?(key))
    end

    options.delete(:except)
    options.delete(:only)

    output = []

    date_measurements = Hash[*date_measurements.first] if options.delete(:highest_measure_only)

    date_measurements.each do |measure, key|
      #name = options[:singularize] == :always || hash[key].between?(-1, 1) ? key.singularize : key
      name = key
      count = hash[key]
      output += ["#{count} #{count > 1 ? "#{name}s" : name}"]
    end

    text = output.join(', ')
    text = text.gsub(', 0 Month, 0 Day','')
    text = text.gsub('0 Yr, 0 Month','')
    text = text.gsub(/0 Yr, (\d+ Months), 0 Day/, "\\1")
    text = text.gsub(' 0 Month',' 0 Months')

    text
  end

  # inspired by https://github.com/radar/dotiw/blob/master/lib/dotiw/time_hash.rb
  class DateHash
    DATE_FRACTIONS = [:days, :months, :years]

    attr_accessor :distance, :smallest, :largest, :begin_date, :end_date, :options

    def initialize(distance, from_date = nil, to_date = nil, options = {})
      self.output = {}
      self.options = options
      self.distance = distance
      self.begin_date = from_date || Date.today
      self.end_date = to_date || (self.begin_date + self.distance.seconds)
      self.smallest, self.largest = [self.begin_date, self.end_date].minmax

      build_date_hash
    end

    def to_hash
      output
    end

    private
    attr_accessor :options, :output

    def build_date_hash
      if accumulate_on = options.delete(:accumulate_on)
        return build_date_hash if accumulate_on == :years
        DATE_FRACTIONS.index(accumulate_on).downto(0) { |i| self.send("build_#{DATE_FRACTIONS[i]}") }
      else
        while distance > 0
          if distance < 28
            build_days
          else # greater than a month
            build_years_months_days
          end
        end
      end

      output
    end

    def build_days
      return output[DAY_UNIT], self.distance = distance.divmod(1)
    end

    def build_months
      build_years_months_days

      if (years = output.delete(YEAR_UNIT)) > 0
        output[MONTH_UNIT] += (years * 12)
      end
    end

    def build_years_months_days
      months = (largest.year - smallest.year) * 12 + (largest.month - smallest.month)
      years, months = months.divmod(12)

      days = largest.day - smallest.day

      if days < 0
        # Convert the last month to days and add to total
        months -= 1
        last_month = largest<<(-1)
        last_day_in_month = 32
        until Date.valid_date?(last_month.year, last_month.month, last_day_in_month) do
          last_day_in_month -= 1
        end
        days += last_day_in_month - 1
      end

      if months < 0
        # Convert a year to months
        years -= 1
        months += 12
      end

      output[YEAR_UNIT]  = years
      output[MONTH_UNIT] = months
      output[DAY_UNIT]   = days

      total_days, self.distance = (begin_date - end_date).abs.divmod(1)
    end
  end # TimeHash


end

