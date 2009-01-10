framework "JSON"
ext_path = File.join(File.dirname(__FILE__), "core_ext")
require File.join(ext_path, 'array')
require File.join(ext_path, 'object')
require File.join(ext_path, 'range')
require File.join(ext_path, 'struct')
require File.join(ext_path, 'symbol')
require File.join(ext_path, 'date_and_time')
require File.join(ext_path, 'exception')
require File.join(ext_path, 'regexp')
require File.join(ext_path, 'enumerable')

module JSON
  
  # The base exception for JSON errors.
  class JSONError < StandardError; end

  # This exception is raised, if a parser error occurs.
  class ParserError < JSONError; end

  # This exception is raised, if the nesting of parsed datastructures is too
  # deep.
  class NestingError < ParserError; end

  # This exception is raised, if a generator or unparser error occurs.
  class GeneratorError < JSONError; end
  
  # Returns an instance of SBJSON
  # SBJSON is framework implementing a strict JSON parser and generator in Objective-C.
  #
  # http://code.google.com/p/json-framework/
  #
  def self.sbjson
    @sbjson ||= SBJSON.new
  end
  
  # Load a ruby data structure from a JSON _source_ and return it. A source can
  # either be a string-like object, an IO like object, or an object responding
  # to the read method. If _proc_ was given, it will be called with any nested
  # Ruby object as an argument recursively in depth first order.
  #
  # This method is part of the implementation of the load/dump interface of
  # Marshal and YAML.
  #
  # Example:
  #
  #    JSON.load("[\"1\",\"2\",\"3\"]")  # => ["1", "2", "3"]
  #
  # :api: public
  #
  def self.load(source, proc = nil)
    # only objects are supported at the moment
    #
    if source.respond_to? :to_str
      source = source.to_str
    elsif source.respond_to? :to_io
      source = source.to_io.read
    else
      source = source.read
    end
    errorp = Pointer.new_with_type('@')
    result = JSON.sbjson.objectWithString(source, error:errorp)
    raise (JSON::ParserError, errorp[0].description) if errorp[0]
    recurse_proc(result, &proc) if proc
    result
  end
  
  def recurse_proc(result, &proc)
    case result
    when Array
      result.each { |x| recurse_proc x, &proc }
      proc.call result
    when Hash
      result.each { |x, y| recurse_proc x, &proc; recurse_proc y, &proc }
      proc.call result
    else
      proc.call result
    end
  end
  private :recurse_proc
  module_function :recurse_proc
  
  # Convert an object into a json string
  #
  # Example:
  #
  #    JSON.dump(["1", "2", "3"])  # => "[\"1\",\"2\",\"3\"]"
  #
  # :api: public
  #
  def self.dump(obj, anIO = nil, limit = nil)
    errorp    = Pointer.new_with_type('@')
    json      = sbjson.stringWithFragment(obj, error:errorp)
    raise errorp[0].description if errorp[0]
    json
  end
  
  # Unparse the Ruby data structure _obj_ into a single line JSON string and
  # return it. _state_ is
  # * a JSON::State object,
  # * or a Hash like object (responding to to_hash),
  # * an object convertible into a hash by a to_h method,
  # that is used as or to configure a State object.
  #
  # It defaults to a state object, that creates the shortest possible JSON text
  # in one line, checks for circular data structures and doesn't allow NaN,
  # Infinity, and -Infinity.
  #
  # A _state_ hash can have the following keys:
  # * *indent*: a string used to indent levels (default: ''),
  # * *space*: a string that is put after, a : or , delimiter (default: ''),
  # * *space_before*: a string that is put before a : pair delimiter (default: ''),
  # * *object_nl*: a string that is put at the end of a JSON object (default: ''), 
  # * *array_nl*: a string that is put at the end of a JSON array (default: ''),
  # * *check_circular*: true if checking for circular data structures
  #   should be done (the default), false otherwise.
  # * *allow_nan*: true if NaN, Infinity, and -Infinity should be
  #   generated, otherwise an exception is thrown, if these values are
  #   encountered. This options defaults to false.
  # * *max_nesting*: The maximum depth of nesting allowed in the data
  #   structures from which JSON is to be generated. Disable depth checking
  #   with :max_nesting => false, it defaults to 19.
  #
  # See also the fast_generate for the fastest creation method with the least
  # amount of sanity checks, and the pretty_generate method for some
  # defaults for a pretty output.
  def self.generate(obj, state = nil)
    if state
      p "State not implemented yet"
      # state = State.from_state(state)
    else
      # state = State.new
    end
    obj.to_json(state)
  end
  
  # Parse the JSON string _source_ into a Ruby data structure and return it.
  #
  # _opts_ can have the following
  # keys:
  # * *max_nesting*: The maximum depth of nesting allowed in the parsed data
  #   structures. Disable depth checking with :max_nesting => false, it defaults
  #   to 19.
  # * *allow_nan*: If set to true, allow NaN, Infinity and -Infinity in
  #   defiance of RFC 4627 to be parsed by the Parser. This option defaults
  #   to false.
  # * *create_additions*: If set to false, the Parser doesn't create
  #   additions even if a matchin class and create_id was found. This option
  #   defaults to true.
  def self.parse(source, opts = {})
    JSON.load(source)
  end
  
end