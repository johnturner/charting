class GoalsController < ApplicationController

  before_filter :load_goal, :only => [:show, :edit, :update, :destroy, :adopt]
  before_filter :require_login, :only => [:new, :edit, :create, :update, :destroy, :export, :download_csv]
  before_filter :require_admin, :only => [:edit, :update]

  def load_goal
    @goal = Goal.find(params[:id])
  end

  def require_admin
    unless @current_user == @goal.admin
      flash[:error] = "You are not the admin of this goal."
      redirect_to request.referer
    end
  end

  def index
     @goals = Goal.paginate :page => params[:page],
                            :per_page => 20,
                            :conditions => {"admin_id" => @current_user.id},
                            :order => "created_at desc"
    @heading = "All my Goals"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @goals }
    end
  end


  def all_goals
    @goals = Goal.paginate :page => params[:page], :per_page => 20
    render :index
  end

  # GET /goals/1
  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # export goals
  def export
    respond_to do |format|
      if @current_user
        @goals = Goal.all
        @export = true
        format.html  # export.html.erb
      else
        format.html  { redirect_to(request.referer) }
      end
    end
  end

  # csv popup
  def download_csv

    # get the filename
    id = params[:id]

    # generate the file
    gen_export_csv(id)

    # filename
    filename = "Export#{id}.csv"

    # create the path
    path = File.expand_path RAILS_ROOT + "/exports/" + filename

    # get the filesize
    size = File.size(path)

    if File.exists?(path) & File.readable?(path)
      # send the file
      send_file path,
                :type => "text/csv",
                :disposition => "attachment",
                :length => size,
                :filename => filename
    end
  end

  # GET /goals/new
  def new
    @goal = Goal.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /goals/1/edit
  def edit
    @goal = Goal.find(params[:id])
  end

  # POST /goals
  def create
    @goal = Goal.find_by_name(params[:goal][:name])
    if @goal
      @goal.users << @current_user
      respond_to do |format|
        format.html { redirect_to(goal_notes_path(@goal), :notice => 'Existing goal added to your list.') }
      end
    else
      @goal = Goal.new(params[:goal])
      @goal.admin = @current_user
      @goal.status = "active"

      respond_to do |format|
        if @goal.save
          @current_user.goals << @goal
          format.html { redirect_to(goal_notes_path(@goal), :notice => 'Goal was successfully created.') }
        else
          format.html { render :action => "new" }
        end
      end
    end
  end

  def adopt
    @current_user.goals << @goal
    @current_user.save!
    redirect_to goal_notes_path(@goal)
  end

  # PUT /goals/1
  def update
    respond_to do |format|
      if @goal.update_attributes(params[:goal])
        format.html { redirect_to(@goal, :notice => 'Goal was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /goals/1
  def destroy
    @current_user.goals.delete @goal

    respond_to do |format|
      format.html { redirect_to(request.referer) }
    end
  end

# helper functions
  def gen_export_csv(id)
    FasterCSV.open("exports/Export#{id}.csv", "w") do |csv|

      # create the title row
      csv << ["Note",
              "Source Name",
              "Source URL",
              "Date Added",
              "Creator"]

      # get the goal
      goal = Goal.find(id)

      # for each note in the goal
      for note in goal.notes do

        csv << [note.body,
                note.source.title,
                note.source.location,
                display_date(note.source.created_at),
                note.user.name]

      end #end for
    end # end open

  end # end def

  # formats the date
  def display_date(date)
    date.strftime("%d %b %y")
  end
end  
