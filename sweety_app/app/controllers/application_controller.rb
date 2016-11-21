class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  private
    def current_user_session
      return @current_user_session ||= UserSession.find
    end

    def current_user
      return @current_user ||= current_user_session && current_user_session.user
    end

    def access_denied
        flash[:notice] = 'Access denied. '

      if current_user
        flash[:notice] += 'You may only access your own information.'
        redirect_to user_readings_path(current_user)
      else
        flash[:notice] += 'Try to log in first.'
        redirect_to root_path
      end
    end

    def is_owner?
      if params[:id]
        # Reading.find(params[:id]).user_id == current_user.id
      else
        User.find(params[:user_id]).id == current_user.id
      end
    end
end