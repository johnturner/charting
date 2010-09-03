class NotesController < ApplicationController
  protect_from_forgery :except => ['create']
  before_filter :require_login, :only => [:new, :edit, :create, :update, :destroy]
  before_filter :require_creator, :only => [:destroy, :edit, :update]
  
  # GET /notes
  # GET /notes.xml
  def index
   if @current_goal
      @notes = @current_goal.notes
    else
      @show_goal = true
      if @current_user
        @notes = Note.find :all, :conditions => {:user_id => @current_user.id}, :include => :goals
      else
        @notes = Note.all
      end
    end
 
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notes }
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
    @note = Note.new(params[:note])

    if params[:source] and params[:source][:location]
      @source = Source.find_by_location params[:source][:location]
      unless @source
        @source = Source.new(params[:source])
      end
      @note.source = @source
    end

    @goals.each do |goal|
      goal = Goal.find_by_name goal
      @note.goals << goal
    end

    @note.user = @current_user
    
    respond_to do |format|
      if @note.save
        format.html { redirect_to(@note, :notice => 'Note was successfully created.') }
        format.xml  { render :xml => @note, :status => :created, :location => @note }
        format.json  { render :json => @note, :status => :created, :location => @note }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
        format.json  { render :json => @note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /notes/1
  # PUT /notes/1.xml
  def update
    @note = Note.find(params[:id])

    respond_to do |format|
      if @note.update_attributes(params[:note])
        format.html { redirect_to(@note, :notice => 'Note was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
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

  def full_body
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
