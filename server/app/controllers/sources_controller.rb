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

  def inbox
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
   @sources = Source.paginate :page => params[:page],
                              :per_page => 10,
                              :include => {:notes => {:goals => :users}}

    #@notabs = true
    @heading = "All Sources"
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
