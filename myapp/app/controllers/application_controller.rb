# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  layout 'global'
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  before_filter :load_current_user
  before_filter :load_goals
  
  def require_login
    unless @current_user
      flash[:error] = "You must be logged in to do that."
      redirect_to (request.referer or '/')
    end
  end

  def load_goals
    if @current_user
      @all_goals = @current_user.goals
    else
      @all_goals = []
    end
      
    params[:goal_id] = params[:id] if self.is_a? GoalsController
    @current_goal = Goal.find params[:goal_id] if params[:goal_id]
  end
 
  def load_current_user
    # Get current user from either being logged in or using api key.
    @current_user = User.find session[:current_user] if session[:current_user]
    @current_user ||= User.find_by_name_and_api_key params[:user][:name], params[:user][:key]
    rescue
    reset_session
  end

  #session[:selected_goal]
  #session[:selected_tab]
end
