module AgeInWords

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
    return age_text if dob.blank? || !(dob.kind_of?(Date) || dob.kind_of?(Time))

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
end
