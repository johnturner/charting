class NotesController < ApplicationController
  protect_from_forgery :except => ['create']
  # GET /notes
  # GET /notes.xml
  def index
   if @current_goal
      @notes = @current_goal.notes
    else
      @notes = Note.all
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
    @note.destroy

    respond_to do |format|
      format.html { redirect_to(notes_url) }
      format.xml  { head :ok }
    end
  end
end
