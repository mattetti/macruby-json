module Enumerable
  def to_json(*a)
    to_a.to_json(*a)
  end
end