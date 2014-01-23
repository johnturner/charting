class Source < ActiveRecord::Base
  validates_length_of :title, :minimum => 1
  has_many :notes

  def to_s
    if title.empty?
      "Untitled"
    else
      title
    end
  end
end
