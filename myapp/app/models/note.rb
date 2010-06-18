class Note < ActiveRecord::Base
  belongs_to :source
  belongs_to :user
  
  has_many :goals, :through => :notegoals
  has_many :notegoals

  def truncated_body
    if body.length > 140
      body[0..140] + "..."
    else
      body
    end
  end
end
