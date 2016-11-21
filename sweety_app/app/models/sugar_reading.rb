class SugarReading < ActiveRecord::Base
  belongs_to :user

  validates :description,
      presence: true,
      length: { minimum: 3 }
  validates :blood_sugar,
      presence: true,
      numericality: { only_integer: true }

  MAX_READINGS = 4
  ERROR_MESSAGE = "Maximum of #{MAX_READINGS} blood glucose readings per day."

  def self.over_daily_readings_limit(user)
    if user.sugar_readings.daily_range(Time.now, user).count >= MAX_READINGS
      return :flash => { :error => ERROR_MESSAGE }
    end
  end

  def self.glucose_max(recordings)
    recordings.map{|x| x.blood_sugar}.max
  end

  def self.glucose_min(recordings)
    recordings.map{|x| x.blood_sugar}.min
  end

  def self.glucose_avg(recordings)
    all_values = recordings.map{|x| x.blood_sugar}
    avg_value = all_values.sum.to_f/all_values.count.to_f
    avg_value
  end

  def self.oldest_report
    (self.minimum(:created_at)).strftime('%d/%m/%Y')
  end

  def self.newest_report
    (self.maximum(:created_at)).strftime('%d/%m/%Y')
  end

  def self.daily_range(date, user)
    return (user.sugar_readings.where(:created_at => (self.date_range(date, date, 'daily'))))
  end

  def self.monthly_range(date, user)
    return (user.sugar_readings.where(:created_at => (self.date_range(date, date, 'monthly'))))
  end

  def self.monthlyToDate_range(date, user)
    return (user.sugar_readings.where(:created_at => (self.date_range(date, date, 'monthToDate'))))
  end


  private
    def self.date_range(start_date, end_date, type)
      if type == 'daily'
        (start_date.beginning_of_day..end_date.end_of_day)
      elsif type == 'monthly'
        (start_date-1.month..end_date.end_of_day)
      else type == 'monthToDate'
        (start_date.beginning_of_month..end_date.end_of_day)
      end
    end

end