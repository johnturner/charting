# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  layout 'global'
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  before_filter :load_goals
  
  def load_goals
    @all_goals = Goal.all
    params[:goal_id] = params[:id] if self.is_a? GoalsController
    @current_goal = Goal.find params[:goal_id] if params[:goal_id]
  end
  
  #session[:selected_goal]
  #session[:selected_tab]
end
