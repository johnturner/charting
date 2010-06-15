class Goal < ActiveRecord::Base
  has_many :users, :through => :usergoals
  has_many :usergoals
  
   has_many :notes, :through => :notegoals
  has_many :notegoals
  def to_s
    name.to_s+" "+status.to_s 
  end
end

#name
#statues
#admin