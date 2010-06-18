class GoalsController < ApplicationController

  before_filter :load_goal, :only => [:show, :edit, :update, :destroy]
  before_filter :require_login, :only => [:new, :edit, :create, :update, :destroy]
  before_filter :require_admin, :only => [:edit, :update, :destroy]

  def load_goal
    @goal = Goal.find(params[:id])
  end

  def require_admin
    unless @current_user == @goal.admin
      flash[:error] = "You are not the admin of this goal."
      redirect_to request.referer
    end
  end

  # GET /goals
  # GET /goals.xml
  def index
    @goals = Goal.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @goals }
      format.json { render :json => @goals }
    end
  end

  # GET /goals/1
  # GET /goals/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @goal }
    end
  end

  # GET /goals/new
  # GET /goals/new.xml
  def new
    @goal = Goal.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @goal }
    end
  end

  # GET /goals/1/edit
  def edit
  end

  # POST /goals
  # POST /goals.xml
  def create
    @goal = Goal.new(params[:goal])
    @goal.admin = @current_user
    @goal.status = "active"

    respond_to do |format|
      if @goal.save
        @current_user.goals << @goal
        format.html { redirect_to(goal_notes_path(@goal), :notice => 'Goal was successfully created.') }
        format.xml  { render :xml => @goal, :status => :created, :location => @goal }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @goal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /goals/1
  # PUT /goals/1.xml
  def update
    respond_to do |format|
      if @goal.update_attributes(params[:goal])
        format.html { redirect_to(@goal, :notice => 'Goal was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @goal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /goals/1
  # DELETE /goals/1.xml
  def destroy
    @goal.destroy

    respond_to do |format|
      format.html { redirect_to(goals_url) }
      format.xml  { head :ok }
    end
  end
end
