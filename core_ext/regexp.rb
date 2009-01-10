class Regexp
  def self.json_create(object)
    new(object['s'], object['o'])
  end

  def to_json(*)
    {
      'json_class' => self.class.name,
      'o' => options,
      's' => source,
    }.to_json
  end
end