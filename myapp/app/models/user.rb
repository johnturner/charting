class User < ActiveRecord::Base
  has_many :goals, :through => :usergoals #user.goals[3].name
  has_many :usergoals #user.usergoals
  #this means that each user has many goals 
  #name , password , email position , bio .
  
end
