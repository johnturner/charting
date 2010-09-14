class Note < ActiveRecord::Base
  belongs_to :source
  belongs_to :user
  
  has_many :goals, :through => :notegoals
  has_many :notegoals
  
  validates_length_of :body, :minimum => 1

  def truncated_body
    if body and body.length > 140
      body[0..140] + "..."
    else
      body
    end
  end
end
