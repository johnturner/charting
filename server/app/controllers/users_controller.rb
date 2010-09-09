class UsersController < ApplicationController
  
  before_filter :load_user, :only => [:show, :edit, :update, :destroy]
  before_filter :must_be_self, :only => [:edit, :update, :destroy]
 
  # GET /users
  # GET /users.xml
  def index
   if @current_goal
      @users = @current_goal.users
    else
      if @current_user
        #Find all people who share a goal with the current user.
        @users = User.find_by_sql(["select distinct users.* from users, usergoals g1, usergoals g2 where users.id = g1.user_id and g1.goal_id = g2.goal_id and g2.user_id = ?", @current_user.id])
      else
        @users = User.all
      end
    end
    respond_to do |format|
      format.html # by default index.html.erb
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        session[:current_user] = @user.id
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
    end
  end

  def login
    user = User.auth(params[:login][:username], 
                     params[:login][:password])
    if user
      flash[:notice] = "Logged in."
      session[:current_user] = user.id
    else
      flash[:error] = "Failed to log in."
    end
    redirect_to request.referer
  end

  def logout
    session[:current_user] = nil
    redirect_to request.referer
  end

  def me
    if @current_user
      redirect_to @current_user
    else
      redirect_to '/'
    end
  end

  def api_key
    if @current_user
      hash = {:user => @current_user.name, :key => @current_user.api_key}
      render :json => hash
    else
      render :text => "Not logged in.", :status => 401
    end
  end

  def verify_api_key
    if User.find_by_name_and_api_key(params[:user][:name], params[:user][:key])
      render :text => "Verified."
    else
      render :text => "Not verified.", :status => 401
    end
  end

  private
  def load_user
    @user = User.find(params[:id])
  end

  def must_be_self
    p @user
    p @current_user
    if @user != @current_user
      flash[:error] = "Cannot perform this action on another user."
      redirect_to request.referer
    end
  end
end
