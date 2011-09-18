class Note < ActiveRecord::Base
  belongs_to :source
  belongs_to :user
  belongs_to :note
  
  has_many :goals, :through => :notegoals
  has_many :notegoals
  
  #validates_length_of :body, :minimum => 1

  def truncated_body
    if body and body.length > 140
      body[0..140] + "..."
    else
      body
    end
  end

  def attachedto
    Goal.find_by_sql ["select distinct goals.* from notes, notegoals, goals
                       where notes.id = notegoals.note_id
                       and notegoals.goal_id = goals.id
                       and notes.major = 't'
                       and notes.id = ?", id]

  end



end
