class SourcesController < ApplicationController
  # GET /sources
  # GET /sources.xml
  def index
   if @current_goal
      @sources = Source.paginate :page => params[:page],
                                 :per_page => 10,
                                 :include => {:notes => :notegoals},
                                 :conditions => {"notegoals.goal_id" => @current_goal.id}
    else
      if @current_user
        #Find all sources for all notes of all goals of the current user.
        @sources = Source.paginate :page => params[:page],
                                   :per_page => 10,
                                   :include => {:notes => {:goals => :users}},
                                   :conditions => {"users.id" => @current_user.id}
      else
        @sources = Source.paginate :page => params[:page],
                                   :per_page => 10
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sources }
    end
  end

  # GET /sources/1
  # GET /sources/1.xml
  def show
    @source = Source.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @source }
    end
  end

  # GET /sources/new
  # GET /sources/new.xml
  def new
    @source = Source.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @source }
    end
  end

  # GET /sources/1/edit
  def edit
    @source = Source.find(params[:id])
  end

  # POST /sources
  # POST /sources.xml
  def create
    @source = Source.new(params[:source])

    respond_to do |format|
      if @source.save
        format.html { redirect_to(@source, :notice => 'Source was successfully created.') }
        format.xml  { render :xml => @source, :status => :created, :location => @source }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @source.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sources/1
  # PUT /sources/1.xml
  def update
    @source = Source.find(params[:id])

    respond_to do |format|
      if @source.update_attributes(params[:source])
        format.html { redirect_to(@source, :notice => 'Source was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @source.errors, :status => :unprocessable_entity }
      end
    end
  end

  #
  def all_sources
    @notes = Note.paginate :page => params[:page],
                           :per_page => 10,
                           :conditions => {"major" => 't'},
                           :order => "updated_at desc",
                           :include => [:goals, :user]

    @heading = "All Sources"
  end

  def my_sources
    @notes = Note.paginate :page => params[:page],
                               :per_page => 10,
                               :conditions => {"notes.user_id" => @current_user.id, "major" => 't'},
                               :order => "updated_at desc",
                               :include => [{:goals => :usergoals}, :user]

    @heading = "My Sources"
  end


  def inbox
    if @current_user
      @notes = Note.paginate_by_sql(["select notes.* from notes where
                                      notes.id not in
                                        (select note_id from notegoals, goals, usergoals where
                                          notegoals.goal_id = goals.id and goals.id = usergoals.goal_id and usergoals.user_id = ?)
                                      and notes.major = 't' and notes.user_id = ?", @current_user, @current_user],
                                      :page => params[:page],
                                      :per_page => 25)
    end
    @heading = "All sources not in any of My Goals"
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

    if params[:from] == "inbox"
      redirect_to :inbox
    elsif params[:from] == "all"
      redirect_to :all_sources
    else
      redirect_to :my_sources
    end

end





  # DELETE /sources/1
  # DELETE /sources/1.xml
  def destroy
    @source = Source.find(params[:id])
    @source.destroy

    respond_to do |format|
      format.html { redirect_to(sources_url) }
      format.xml  { head :ok }
    end
  end
end
