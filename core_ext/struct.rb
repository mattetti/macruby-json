class Struct
  def self.json_create(object)
    new(*object['v'])
  end

  def to_json(*args)
    klass = self.class.name
    klass.empty? and raise JSON::JSONError, "Only named structs are supported!"
    {
      'json_class' => klass,
      'v'     => values,
    }.to_json(*args)
  end
end