class Exception
  def self.json_create(object)
    result = new(object['m'])
    result.set_backtrace object['b']
    result
  end

  def to_json(*args)
    {
      'json_class' => self.class.name,
      'm'   => message,
      'b' => backtrace,
    }.to_json(*args)
  end
end