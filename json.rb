# Check the ObjC source code available in src
# if you modify the source code, you will need to rebuild
# the dynlib and rename it BSJON.bundle
require File.join(File.dirname(__FILE__), 'lib', 'BSJSON')

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
    
    begin
      result = Hash.dictionaryWithJSONString(source)
    rescue => e
      raise ParserError, e
    else
      recurse_proc(result, &proc) if proc
      ## TEMP LIMITED HACK
      if result.is_a?(Array)
        result.map do |obj|
          obj_d, obj_l = obj.doubleValue, obj.longValue
          obj_d == obj_l ? obj_l : obj_d
        end
      else
        result
      end
    ##
    end
    
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
    begin
      obj.to_json
    rescue => e
      raise GeneratorError, e
    end
  end
  
  def self.generate(obj, state = nil)
    puts "State not implemented yet" if state
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
    p "Options not supported yet" unless opts.empty?
    JSON.load(source)
  end
  
end