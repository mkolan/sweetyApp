class SugarReadingsController < ApplicationController
  # before_filter :access_denied, :unless => :is_owner?

  def index
    @sugar_readings = current_user.sugar_readings
  end

  def show
    @user = User.find(params[:user_id])
    @reading = @user.readings.find(params[:id])
  end

  def new
    @reading = current_user.sugar_readings.build
  end

  def edit
    @reading = current_user.sugar_readings.find(params[:id])
  end

  def create
    check_over_daily_readings_limit(current_user) and return
    reading = current_user.sugar_readings.build(reading_params)
    if reading.save
      redirect_to sugar_readings_path
    else
      render 'new'
    end

  end

  def update
    reading = SugarReading.find(params[:id])

    if reading.update(reading_params)
      redirect_to sugar_readings_path
    else
      render 'edit'
    end

  end

  def destroy
    @reading = SugarReading.find(params[:id])
    @reading.destroy

    redirect_to sugar_readings_path
  end

  def check_over_daily_readings_limit(user)
    if error = SugarReading.over_daily_readings_limit(user)
      flash[:error] = "ERROR: Maximum of 4 blood glucose readings per day."
      redirect_to sugar_readings_path(user) #, error
    else
      return false
    end

  end

private
  def reading_params
    massAssignable = [:description, :blood_sugar]
    params.require(:sugar_reading).permit(massAssignable)
  end

end