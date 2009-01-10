class Array
  def to_json(*args)
    return self if self.empty?
    errorp    = Pointer.new_with_type('@')
    obj       = JSON.sbjson.stringWithFragment(self, error:errorp)
    raise errorp[0].description if errorp[0]
    obj
  end
end