class Range
  def self.json_create(object)
    new(*object['a'])
  end

  def to_json(*args)
    {
      'json_class'   => self.class.name,
      'a'         => [ first, last, exclude_end? ]
    }.to_json(*args)
  end
end