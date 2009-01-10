require 'date'

class Time
  def self.json_create(object)
    if usec = object.delete('u') # used to be tv_usec -> tv_nsec
      object['n'] = usec * 1000
    end
    if respond_to?(:tv_nsec)
      at(*object.values_at('s', 'n'))
    else
      at(object['s'], object['n'] / 1000)
    end
  end

  def to_json(*args)
    {
      'json_class' => self.class.name,
      's' => tv_sec,
      'n' => respond_to?(:tv_nsec) ? tv_nsec : tv_usec * 1000
    }.to_json(*args)
  end
end

class Date
  def self.json_create(object)
    civil(*object.values_at('y', 'm', 'd', 'sg'))
  end

  alias start sg unless method_defined?(:start)

  def to_json(*args)
    {
      'json_class' => self.class.name,
      'y' => year,
      'm' => month,
      'd' => day,
      'sg' => start,
    }.to_json(*args)
  end
end

class DateTime
  def self.json_create(object)
    args = object.values_at('y', 'm', 'd', 'H', 'M', 'S')
    of_a, of_b = object['of'].split('/')
    if of_b and of_b != '0'
      args << Rational(of_a.to_i, of_b.to_i)
    else
      args << of_a
    end
    args << object['sg']
    civil(*args)
  end

  alias start sg unless method_defined?(:start)

  def to_json(*args)
    {
      'json_class' => self.class.name,
      'y' => year,
      'm' => month,
      'd' => day,
      'H' => hour,
      'M' => min,
      'S' => sec,
      'of' => offset.to_s,
      'sg' => start,
    }.to_json(*args)
  end
end