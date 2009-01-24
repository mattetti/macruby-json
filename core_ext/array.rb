class Array
  def to_json(*args)
    return self if self.empty?
    self.toJson
  end
end