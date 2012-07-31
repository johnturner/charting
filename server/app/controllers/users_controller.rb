class UsersController < ApplicationController
  
  before_filter :load_user, :only => [:show, :edit, :update, :destroy]
  before_filter :must_be_self, :only => [:edit, :update, :destroy]
  protect_from_forgery :except => [:api_key, :login]
 
  # GET /users
  # GET /users.xml
  def index
   if @current_goal
      @link_name = "users"
      @users = User.paginate :page => params[:page],
                             :per_page => 10,
                             :include => [:usergoals, :goals]
                             # ,
                             #:conditions => {"usergoals.goal_id" => @current_goal.id}
    else
      if @current_user
        #Find all people who share a goal with the current user.
        #(Kind of horrible)
        @link_name = "users"
        @users = User.paginate :page => params[:page],
                               :per_page => 10,
                               :joins => {:goals => :usergoals},
                               :select => 'distinct users.*'
                               #,
                               #:conditions => {"usergoals_goals.user_id" => @current_user.id}
      else
        @link_name = "users"
        @users = User.paginate :page => params[:page],
                               :per_page => 10
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
    redirect_to '/'
  end

  def me
    if @current_user
      redirect_to @current_user
    else
      redirect_to '/'
    end
  end

  def api_key
    
    # Allow login parameters to be passed when requesting an api key.
    if params[:login]
      user = User.auth(params[:login][:username], 
                       params[:login][:password])
      if user
        session[:current_user] = user.id
        @current_user = user
      end
    end
    
    respond_to do |format|
      if @current_user
        info = {:apiKey => {:user => @current_user.name, :key => @current_user.api_key}}
        format.xml  {render :xml => @current_user.to_xml(:only => [:name, :api_key])}
        format.json {render :json => @current_user.to_json(:only => [:name, :api_key])}
        format.js   {render :json => @current_user.to_json(:only => [:name, :api_key]), :callback => 'charting.apiKey'}
      else
        format.xml  {render :text => '<error>Not logged in.</error>', :status => :forbidden}
        format.json {render :json => '"Not logged in."', :status => :forbidden}
        format.js   {render :json => '"Not logged in."', :callback => 'charting.apiKeyError'}
      end
    end
  end

  def verify_api_key
    respond_to do |format|
      if params[:user] and User.find_by_name_and_api_key(params[:user][:name], params[:user][:key])
        format.xml  {render :text => '<apiKey><status>Verified</status></apiKey>'}
        format.json {render :json => '"Verified."'}
        format.js   {render :json => '"Verified."', :callback => 'charting.keyVerified'}
      else
        format.xml  {render :text => '<apiKey><status>Failed</status></apiKey>'}
        format.json {render :text => '"Invalid."', :status => :forbidden}
        format.js   {render :json => '"Invalid."', :callback => 'charting.keyInvalid'}
      end
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
