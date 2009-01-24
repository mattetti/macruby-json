class Hash
  def to_json(*args)
    p "Hash to_json"
    self.jsonStringValue
  end
end