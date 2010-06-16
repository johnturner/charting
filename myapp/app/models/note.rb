class Note < ActiveRecord::Base
  belongs_to :source
  
  has_many :goals, :through => :notegoals
  has_many :notegoals
end
