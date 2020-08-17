class ApplicationController < ActionController::Base

    helper_method :current_user, :logged_in?

    def current_user
        @current_user ||= User.find_by(session_token: session[:session_token])
    end

    def logged_in?
        !!current_user # current_user.nil? ? false : true
    end

    def login!(user)
        user.reset_session_token!
        session[:session_token] = user.session_token
    end

    def logout!
        current_user.reset_session_token!
        session[:session_token] = nil
    end

    def ensure_login
        redirect_to new_session_url unless logged_in?
    end

    def already_loggedin
        redirect_to cats_url if logged_in?
    end






end
