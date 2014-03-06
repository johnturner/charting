class NotesController < ApplicationController
  protect_from_forgery :except => ['create']
  before_filter :require_login, :only => [:new, :edit, :create, :update, :destroy]
  before_filter :require_creator, :only => [:destroy, :edit, :update]
  
  # GET /notes
  # GET /notes.xml
  def index
   if @current_goal
      @notes = Note.find_by_sql ["select notes.* from notes, notegoals where notegoals.goal_id = ? and notes.id = notegoals.note_id and major = 't'", @current_goal.id]
#      @notes = Note.paginate :page => params[:page],
#                             :per_page => 10,
#                             :conditions => {"notegoals.goal_id" => @current_goal.id, "major" => 't'},
#                             :include => [:notegoals, :user, :goals]
    else
      if @current_user
        @notes = Note.paginate :page => params[:page],
                               :per_page => 10,
                               :conditions => {"usergoals.user_id" => @current_user.id, "major" => 't'},
                               :include => [{:goals => :usergoals}, :user]
      else
        @notes = Note.paginate :page => params[:page],
                               :per_page => 10,
                               :conditions => {"major" => 't'},
                               :include => [:goals, :user]
      end
    end
 
    @heading = "All my Notes"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notes }
    end
  end

  #Notes from all users in the system, regardless of who is logged in
  def all_goals
    @notes = Note.paginate :page => params[:page],
                           :per_page => 10,
                           :include => [:goals, :user]
    #@notabs = true
    @heading = "All Notes"
  end

  #Notes from all users in the system, regardless of who is logged in
  def all_notes
    @notes = Note.paginate :page => params[:page],
                           :per_page => 10,
                           :conditions => {"major" => 't'},
                           :order => "updated_at desc",
                           :include => [:goals, :user]
    
    @heading = "All Notes"
  end

  def my_notes
    @notes = Note.paginate :page => params[:page],
                               :per_page => 10,
                               :conditions => {"notes.user_id" => @current_user.id, "major" => 't'},
                               :order => "updated_at desc",
                               :include => [{:goals => :usergoals}, :user]

    @heading = "My Notes"
  end


  def inbox 
    #@notabs = true
    if @current_user
      @notes = Note.paginate_by_sql(["select notes.* from notes where 
                                      notes.id not in 
                                        (select note_id from notegoals, goals, usergoals where 
                                          notegoals.goal_id = goals.id and goals.id = usergoals.goal_id and usergoals.user_id = ?)
                                      and notes.major = 't' and notes.user_id = ?", @current_user, @current_user],
                                      :page => params[:page],
                                      :per_page => 25)
    end
    @heading = "All Notes not in any of My Goals"
  end

  def set_goals
    @note = Note.find(params[:id])
    if params[:note]
      @goals = params[:note][:goals]
    end
    @goals ||= []
    
    @note.goals = @goals.map{|g| Goal.find_by_name(g)}
    p @note.goals
    @note.save!
    
#    if params[:goal]
#      @current_goal = Goal.find(params[:goal][:id])
#    end
    
#    if @current_goal
#      @notes = Note.paginate :page => params[:page],
#                             :per_page => 10,
#                             :conditions => {"notegoals.goal_id" => @current_goal.id},
#                             :include => [:notegoals, :user, :goals]
#    else
#      @notes = Note.paginate :page => params[:page],
#                             :per_page => 10,
#                             :conditions => {:user_id => @current_user.id},
#                             :include => [:goals, :user]
#    end
#    render :partial => 'note_table'

    if params[:from] == "inbox"
      redirect_to :inbox
    elsif params[:from] == "all"
      redirect_to :all_notes
    else
      redirect_to :my_notes
    end

end

  # GET /notes/1
  # GET /notes/1.xml
  def show
    @note = Note.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @note }
    end
  end

  # GET /notes/new
  # GET /notes/new.xml
  def new
    @note = Note.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @note }
    end
  end

  # GET /notes/1/edit
  def edit
    @note = Note.find(params[:id])
  end

  # POST /notes
  # POST /notes.xml
  def create
    if params[:note] and params[:note][:goals]
      @goals = params[:note][:goals]
      params[:note].delete :goals
    else
      @goals = []
    end
    @note = Note.new(params[:note].permit(:body))

    if params[:source] and params[:source][:location]
      @source = Source.find_by_location params[:source][:location]
      unless @source
        @source = Source.new(params[:source].permit(:location, :title))
      end
      puts @source
      @note.source = @source
    end

    @goals.each do |goal|
      goal = Goal.find_by_name goal
      @note.goals << goal
    end

    @note.user = @current_user
    
    respond_to do |format|
      if @note.save
        # if it's a comment, redirect to table
        if params[:note][:parent_id]
          format.html { redirect_to :back }
        # else it's a new note
        else
          format.html { redirect_to @note }
        end
        format.xml  { render :xml => @note, :status => :created, :location => @note}
        format.json { render :json => @note, :status => :created, :location => @note}
        format.js   { render :json => @note, :callback => 'charting.noteSuccess' }
      else
        format.html { render :new }
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
        format.json { render :json => @note.errors, :status => :unprocessable_entity }
        format.js   { render :json => @note.errors, :callback => 'charting.noteError' }
      end
    end
  end

  def add_comment
    @note = Note.new(params[:note])
    @note.save

    @source_id = params[:source_id]
    @goal_id = params[:goal_id]
    @parent_id = params[:note][:parent_id]

    respond_to do |format|
      format.js
    end
  end

  def add_sub_comment
    @note = Note.new(params[:note].permit(:user, :source, :doctype, :title, :note))
    @note.save

    @source_id = params[:source_id]
    @goal_id = params[:goal_id]
    @parent_id = params[:note][:parent_id]

    respond_to do |format|
      format.js
    end
  end

  def add_sub_sub_comment
    @note = Note.new(params[:note].permit(:body, :parent_id))
    @note.save

    @source_id = params[:source_id]
    @goal_id = params[:goal_id]
    @parent_id = params[:note][:parent_id]

    respond_to do |format|
      format.js
    end
  end

  # PUT /notes/1
  # PUT /notes/1.xml
  def update
    @note = Note.find(params[:id])

    if params[:major]
      params[:note][:major] = params[:major]
    end

    respond_to do |format|
      if @note.update_attributes(params[:note].permit(:body))
        # if it's a a promoted comment
        #if params[:major]
          #format.html { redirect_to :back }
        #else
          format.html { redirect_to(@note, :notice => 'Note was successfully updated.') }
        #end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /notes/1
  # PUT /notes/1.xml
  def promote
    @note = Note.find(params[:id])
    @note.major = 't'
    @note.source_id = params[:source_id]
    @goal = Goal.find(params[:goal_id])

    @note.goals << @goal

    respond_to do |format|
      if @note.save
        format.html { redirect_to :back }
        format.xml  { head :ok }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.xml
  def destroy
    @note = Note.find(params[:id])
    if @current_goal
      @note.goals -= @current_goal
      @note.save
    else
      @note.destroy
    end

    respond_to do |format|
      format.html { redirect_to(request.referer) }
      format.xml  { head :ok }
    end
  end

  def full_text
    @note = Note.find(params[:id])
    if @note
      render :text => @note.body
    else
      render :text => "Error, note not found."
    end
  end
end

private
def require_creator
  @note = Note.find(params[:id])
  unless @current_user == @note.user
    flash[:error] = "Cannot change someone else's note."
    redirect_to(request.referer || "/")
  end
end
