class Goal < ActiveRecord::Base
  has_many :users, :through => :usergoals
  has_many :usergoals
  
  has_many :notes, :through => :notegoals
  has_many :notegoals

  validates_uniqueness_of :name
  
  belongs_to :admin, :class_name => "User"

  def to_s
    name.to_s
  end

  def sources
    Source.find_by_sql ["select distinct sources.* from sources, notes, goals, notegoals 
                         where sources.id = notes.source_id 
                         and notegoals.note_id = notes.id 
                         and notegoals.goal_id = ?", id]
  end
end

#name
#statues
#admin
