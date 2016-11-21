class ReportsController < ApplicationController
  def index
    @user_id = params[:format]
  end

  def daily
    user = User.find params[:format]
    end_date = Date.parse(params[:on_date])
    @report = SugarReading.daily_range(end_date, user)
  end

  def monthly
    user = User.find params[:format]
    end_date = Date.parse(params[:to_date])
    @report = SugarReading.monthly_range(end_date, user)
  end

  def month_to_date
    user = User.find params[:format]
    end_date = Date.parse(params[:to_date])
    @report = SugarReading.monthlyToDate_range(end_date, user)
  end

  def patients_list
    @patients = User.where(user_type: "patient")
  end
end