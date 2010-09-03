class SearchController < ApplicationController
  def search
    @text = params[:search][:text]
    @notes = Note.find :all, :conditions => ["body like ?", "%"+@text+"%"]
    @goals = Goal.find :all, :conditions => ["name like ?", "%"+@text+"%"]
    @sources = Source.find :all, :conditions => ["title like ?", "%"+@text+"%"]
  end
end
