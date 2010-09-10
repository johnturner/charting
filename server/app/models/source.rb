class Source < ActiveRecord::Base
  has_many :notes

  def to_s
    if title.empty?
      "Untitled"
    else
      title
    end
  end
end
