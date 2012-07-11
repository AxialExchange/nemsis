require 'chronic'

module AgeInWords

  YEAR_UNIT  = "Yr"
  MONTH_UNIT = "Month"
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
  DAY_MAX_DAYS    = 30
  WEEK_MAX_DAYS   = 3 * 30
  MONTH_MAX_DAYS  = 365 * 2
  ERROR_TEXT = "Missing DOB"

  def get_age_in_words dob
    age_text = ERROR_TEXT
    return age_text if dob.nil? || !(dob.kind_of?(Date) || dob.kind_of?(Time))

    dob = Date.parse(dob.strftime('%Y-%m-%d')) if dob.kind_of?(Time)

    age_in_days = (Date.today - dob).to_i

    modulus = 0

    if age_in_days <= DAY_MAX_DAYS
      age = age_in_days
      age_text = "#{age} days"
    elsif age_in_days <= WEEK_MAX_DAYS
      age,modulus = age_in_days.divmod(7)
      age_text = "#{age} weeks"
    elsif age_in_days <= MONTH_MAX_DAYS
      age,modulus = age_in_days.divmod(30)
      age_text = "#{age} months"
    else
      age,modulus = age_in_days.divmod(365)
      age_text = "#{age} years"
    end
    age_text
  end

  def to_age_in_words dob
    age_text = ERROR_TEXT
    return age_text if dob.nil? || (!dob.respond_to?("to_date") && !dob.kind_of?(String))

    if dob.kind_of?(String)
      dob = Chronic.parse(dob)
    end

    dob = dob.to_date

    from_date = dob
    to_date = Date.today
    hash = DateHash.new((from_date - to_date).abs, from_date, to_date, {}).to_hash
    age_text = display_date_in_words(hash)
  end

  def display_date_in_words(hash, options = {})
    date_measurements = Hash.new
    date_measurements[:years]  = YEAR_UNIT
    date_measurements[:months] = MONTH_UNIT
    date_measurements[:days]   = DAY_UNIT

    # Remove all the values that are nil or excluded. Keep the required ones.
    date_measurements.delete_if do |measure, key|
      hash[key].nil? || hash[key].zero? || (!options[:except].nil? && options[:except].include?(key)) ||
          (options[:only] && !options[:only].include?(key))
    end

    options.delete(:except)
    options.delete(:only)

    output = []

    date_measurements = Hash[*date_measurements.first] if options.delete(:highest_measure_only)

    date_measurements.each do |measure, key|
      name = options[:singularize] == :always || hash[key].between?(-1, 1) ? key.singularize : key
      count = hash[key]
      output += ["#{count} #{count > 1 ? "#{name}s" : name}"]
    end

    options.delete(:singularize)

    # maybe only grab the first few values
    if options[:precision]
      output = output[0...options[:precision]]
      options.delete(:precision)
    end

    output.join(', ')
  end

  # inspired by https://github.com/radar/dotiw/blob/master/lib/dotiw/time_hash.rb
  class DateHash
    DATE_FRACTIONS = [:days, :months, :years]

    attr_accessor :distance, :smallest, :largest, :from_date, :to_date, :options

    def initialize(distance, from_date = nil, to_date = nil, options = {})
      self.output = {}
      self.options = options
      self.distance = distance
      self.from_date = from_date || Date.today
      self.to_date = to_date || (self.from_date + self.distance.seconds)
      self.smallest, self.largest = [self.from_date, self.to_date].minmax

      I18n.locale = options[:locale] if options[:locale]

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
      output[DAY_UNIT], self.distance = distance.divmod(1)
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
        last_month = largest.advance(:months => -1)
        days += Time.days_in_month(last_month.month, last_month.year)
      end

      if months < 0
        # Convert a year to months
        years -= 1
        months += 12
      end

      output[YEAR_UNIT]  = years
      output[MONTH_UNIT] = months
      output[DAY_UNIT]   = days

      total_days, self.distance = (from_date - to_date).abs.divmod(1)
    end
  end # TimeHash


end
