module Enumerable
  def to_json(*a)
    self.is_a?(Hash) ? self.jsonStringValue : to_a.to_json(*a)
  end
end