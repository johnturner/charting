# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  ActiveRecord::Base.include_root_in_json = false
end
