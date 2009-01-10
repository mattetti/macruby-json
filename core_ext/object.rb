class Object

  def to_json(*args)
    result = { 'json_class' => self.class.name }
    instance_variables.each do |name|
      result[name[1..-1]] = instance_variable_get name
    end
    result.to_json(*args)
  end

end