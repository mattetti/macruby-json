class Symbol
  def to_json(*a)
    to_s.to_json(*a)
  end
end