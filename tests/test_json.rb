require 'test/unit'
require File.join(File.dirname(__FILE__), "..", "json")
require 'stringio'

class TC_JSON < Test::Unit::TestCase

  def setup
    @ary = [1, "foo", 3.14, 4711.0, 2.718, nil, [1,-2,3], false, true].map do
      |x| [x]
    end
    @ary_to_parse = ["1", '"foo"', "3.14", "4711.0", "2.718", "null",
      "[1,-2,3]", "false", "true"].map do
      |x| "[#{x}]"
    end
    @hash = {
      'a' => 2,
      'b' => 3.141,
      'c' => 'c',
      'd' => [ 1, "b", 3.14 ],
      'e' => { 'foo' => 'bar' },
      'g' => "\"\0\037",
      'h' => 1000.0,
      'i' => 0.001
    }
    @json = '{"a":2,"b":3.141,"c":"c","d":[1,"b",3.14],"e":{"foo":"bar"},' +
      '"g":"\\"\\u0000\\u001f","h":1.0E3,"i":1.0E-3}'
  end
    suite << TC_JSON.suite

  def assert_equal_float(expected, is)
    assert_in_delta(expected.first, is.first, 1e-2)
  end
  
  def test_gdata
    json = %Q~{"responseData": {"results":[{"GsearchResultClass":"GwebSearch","unescapedUrl":"http://www.natalieportman.com/","url":"http://www.natalieportman.com/","visibleUrl":"www.natalieportman.com","cacheUrl":"http://www.google.com/search?q\u003dcache:9hGoJVGBJ2sJ:www.natalieportman.com","title":"\u003cb\u003eNatalie Portman\u003c/b\u003e . Com - News","titleNoFormatting":"Natalie Portman . Com - News","content":"\u003cb\u003eNatalie Portman\u003c/b\u003e, Star Wars, Phantom Menace, Attack of the Clones, Amidala, Leon,   Professional, Where The Heart Is, Anywhere But Here, Seagull, Heat, \u003cb\u003e...\u003c/b\u003e"},{"GsearchResultClass":"GwebSearch","unescapedUrl":"http://www.imdb.com/name/nm0000204/","url":"http://www.imdb.com/name/nm0000204/","visibleUrl":"www.imdb.com","cacheUrl":"http://www.google.com/search?q\u003dcache:JLzGjsYYdlkJ:www.imdb.com","title":"\u003cb\u003eNatalie Portman\u003c/b\u003e","titleNoFormatting":"Natalie Portman","content":"\u003cb\u003eNatalie Portman\u003c/b\u003e was born in Jerusalem, Israel, to Avner, a fertility specialist.  .. Visit IMDb for Photos, Filmography, Discussions, Bio, News, Awards, \u003cb\u003e...\u003c/b\u003e"},{"GsearchResultClass":"GwebSearch","unescapedUrl":"http://en.wikipedia.org/wiki/Natalie_Portman","url":"http://en.wikipedia.org/wiki/Natalie_Portman","visibleUrl":"en.wikipedia.org","cacheUrl":"http://www.google.com/search?q\u003dcache:32A4VEkC23gJ:en.wikipedia.org","title":"\u003cb\u003eNatalie Portman\u003c/b\u003e - Wikipedia, the free encyclopedia","titleNoFormatting":"Natalie Portman - Wikipedia, the free encyclopedia","content":"\u003cb\u003eNatalie Portman\u003c/b\u003e (Hebrew: נטלי פורטמן\u200e; born \u003cb\u003eNatalie\u003c/b\u003e Hershlag June 9, 1981) is an   Israeli-American actress. \u003cb\u003ePortman\u003c/b\u003e began her career in the early 1990s, \u003cb\u003e...\u003c/b\u003e"},{"GsearchResultClass":"GwebSearch","unescapedUrl":"http://www.natalie-p.org/","url":"http://www.natalie-p.org/","visibleUrl":"www.natalie-p.org","cacheUrl":"http://www.google.com/search?q\u003dcache:wv-CVcMW2SEJ:www.natalie-p.org","title":"\u003cb\u003eNatalie Portman\u003c/b\u003e ORG ++{\u003cb\u003enatalie\u003c/b\u003e-p.org} | your premiere \u003cb\u003eNATALIE\u003c/b\u003e \u003cb\u003e...\u003c/b\u003e","titleNoFormatting":"Natalie Portman ORG ++{natalie-p.org} | your premiere NATALIE ...","content":"Aug 30, 2008 \u003cb\u003e...\u003c/b\u003e media on Miss \u003cb\u003ePortman\u003c/b\u003e. You may recognize \u003cb\u003eNatalie\u003c/b\u003e for her roles in \u003cb\u003e....\u003c/b\u003e is in in   no way affiliated with \u003cb\u003eNatalie Portman\u003c/b\u003e or her management. \u003cb\u003e...\u003c/b\u003e"}],"cursor":{"pages":[{"start":"0","label":1},{"start":"4","label":2},{"start":"8","label":3},{"start":"12","label":4},{"start":"16","label":5},{"start":"20","label":6},{"start":"24","label":7},{"start":"28","label":8}],"estimatedResultCount":"513000","currentPageIndex":0,"moreResultsUrl":"http://www.google.com/search?oe\u003dutf8\u0026ie\u003dutf8\u0026source\u003duds\u0026start\u003d0\u0026hl\u003den\u0026q\u003dNatalie+Portman"}}, "responseDetails": null, "responseStatus": 200}~
    parsed = JSON.parse(json)
    assert_equal(parsed, [])
  end

  def test_parse_simple_arrays
    assert_equal([], JSON.parse('[]'))
    assert_equal([], JSON.parse('  [  ] '))
    assert_equal([nil], JSON.parse('[null]'))
    assert_equal([false], JSON.parse('[false]'))
    assert_equal([true], JSON.parse('[true]'))
    assert_equal([-23], JSON.parse('[-23]'))
    assert_equal([23], JSON.parse('[23]'))
    assert_equal([0.23], JSON.parse('[0.23]'))
    assert_equal([0.0], JSON.parse('[0e0]'))
    assert_raises(JSON::ParserError) { JSON.parse('[+23.2]') }
    assert_raises(JSON::ParserError) { JSON.parse('[+23]') }
    assert_raises(JSON::ParserError) { JSON.parse('[.23]') }
    assert_raises(JSON::ParserError) { JSON.parse('[023]') }
    assert_equal_float [3.141], JSON.parse('[3.141]')
    assert_equal_float [-3.141], JSON.parse('[-3.141]')
    assert_equal_float [3.141], JSON.parse('[3141e-3]')
    assert_equal_float [3.141], JSON.parse('[3141.1e-3]')
    assert_equal_float [3.141], JSON.parse('[3141E-3]')
    assert_equal_float [3.141], JSON.parse('[3141.0E-3]')
    assert_equal_float [-3.141], JSON.parse('[-3141.0e-3]')
    assert_equal_float [-3.141], JSON.parse('[-3141e-3]')
    assert_raises(ParserError) { JSON.parse('[NaN]') }
    assert JSON.parse('[NaN]', :allow_nan => true).first.nan?
    assert_raises(ParserError) { JSON.parse('[Infinity]') }
    assert_equal [1.0/0], JSON.parse('[Infinity]', :allow_nan => true)
    assert_raises(ParserError) { JSON.parse('[-Infinity]') }
    assert_equal [-1.0/0], JSON.parse('[-Infinity]', :allow_nan => true)
    assert_equal([""], JSON.parse('[""]'))
    assert_equal(["foobar"], JSON.parse('["foobar"]'))
    assert_equal([{}], JSON.parse('[{}]'))
  end

#   def test_parse_simple_objects
#     assert_equal({}, JSON.parse('{}'))
#     assert_equal({}, JSON.parse(' {   }   '))
#     assert_equal({ "a" => nil }, JSON.parse('{   "a"   :  null}'))
#     assert_equal({ "a" => nil }, JSON.parse('{"a":null}'))
#     assert_equal({ "a" => false }, JSON.parse('{   "a"  :  false  }  '))
#     assert_equal({ "a" => false }, JSON.parse('{"a":false}'))
#     assert_raises(JSON::ParserError) { JSON.parse('{false}') }
#     assert_equal({ "a" => true }, JSON.parse('{"a":true}'))
#     assert_equal({ "a" => true }, JSON.parse('  { "a" :  true  }   '))
#     assert_equal({ "a" => -23 }, JSON.parse('  {  "a"  :  -23  }  '))
#     assert_equal({ "a" => -23 }, JSON.parse('  { "a" : -23 } '))
#     assert_equal({ "a" => 23 }, JSON.parse('{"a":23  } '))
#     assert_equal({ "a" => 23 }, JSON.parse('  { "a"  : 23  } '))
#     assert_equal({ "a" => 0.23 }, JSON.parse(' { "a"  :  0.23 }  '))
#     assert_equal({ "a" => 0.23 }, JSON.parse('  {  "a"  :  0.23  }  '))
#   end
# 
#   begin
#     require 'permutation'
#     def test_parse_more_complex_arrays
#       a = [ nil, false, true, "foßbar", [ "n€st€d", true ], { "nested" => true, "n€ßt€ð2" => {} }]
#       perms = Permutation.for a
#       perms.each do |perm|
#         orig_ary = perm.project
#         json = pretty_generate(orig_ary)
#         assert_equal orig_ary, JSON.parse(json)
#       end
#     end
# 
#     def test_parse_complex_objects
#       a = [ nil, false, true, "foßbar", [ "n€st€d", true ], { "nested" => true, "n€ßt€ð2" => {} }]
#       perms = Permutation.for a
#       perms.each do |perm|
#         s = "a"
#         orig_obj = perm.project.inject({}) { |h, x| h[s.dup] = x; s = s.succ; h }
#         json = pretty_generate(orig_obj)
#         assert_equal orig_obj, JSON.parse(json)
#       end
#     end
#   rescue LoadError
#     warn "Skipping permutation tests."
#   end
# 
#   def test_parse_arrays
#     assert_equal([1,2,3], JSON.parse('[1,2,3]'))
#     assert_equal([1.2,2,3], JSON.parse('[1.2,2,3]'))
#     assert_equal([[],[[],[]]], JSON.parse('[[],[[],[]]]'))
#   end
# 
#   def test_parse_values
#     assert_equal([""], JSON.parse('[""]'))
#     assert_equal(["\\"], JSON.parse('["\\\\"]'))
#     assert_equal(['"'], JSON.parse('["\""]'))
#     assert_equal(['\\"\\'], JSON.parse('["\\\\\\"\\\\"]'))
#     assert_equal(["\"\b\n\r\t\0\037"],
#       JSON.parse('["\"\b\n\r\t\u0000\u001f"]'))
#     for i in 0 ... @ary.size
#       assert_equal(@ary[i], JSON.parse(@ary_to_parse[i]))
#     end
#   end
# 
#   def test_parse_array
#     assert_equal([], JSON.parse('[]'))
#     assert_equal([], JSON.parse('  [  ]  '))
#     assert_equal([1], JSON.parse('[1]'))
#     assert_equal([1], JSON.parse('  [ 1  ]  '))
#     assert_equal(@ary,
#       JSON.parse('[[1],["foo"],[3.14],[47.11e+2],[2718.0E-3],[null],[[1,-2,3]]'\
#       ',[false],[true]]'))
#     assert_equal(@ary, JSON.parse(%Q{   [   [1] , ["foo"]  ,  [3.14] \t ,  [47.11e+2] 
#       , [2718.0E-3 ],\r[ null] , [[1, -2, 3 ]], [false ],[ true]\n ]  }))
#   end
# 
#   def test_parse_object
#     assert_equal({}, JSON.parse('{}'))
#     assert_equal({}, JSON.parse('  {  }  '))
#     assert_equal({'foo'=>'bar'}, JSON.parse('{"foo":"bar"}'))
#     assert_equal({'foo'=>'bar'}, JSON.parse('    { "foo"  :   "bar"   }   '))
#   end
# 
#   def test_parser_reset
#     JSON.parser = Parser.new(@json)
#     assert_equal(@hash, JSON.parser.parse)
#     assert_equal(@hash, JSON.parser.parse)
#   end
# 
#   def test_comments
#     json = <<EOT
# {
#   "key1":"value1", // eol comment
#   "key2":"value2"  /* multi line
#                     *  comment */,
#   "key3":"value3"  /* multi line
#                     // nested eol comment
#                     *  comment */
# }
# EOT
#     assert_equal(
#       { "key1" => "value1", "key2" => "value2", "key3" => "value3" },
#       JSON.parse(json))
#     json = <<EOT
# {
#   "key1":"value1"  /* multi line
#                     // nested eol comment
#                     /* illegal nested multi line comment */
#                     *  comment */
# }
# EOT
#     assert_raises(ParserError) { JSON.parse(json) }
#     json = <<EOT
# {
#   "key1":"value1"  /* multi line
#                    // nested eol comment
#                    closed multi comment */
#                    and again, throw an Error */
# }
# EOT
#     assert_raises(ParserError) { JSON.parse(json) }
#     json = <<EOT
# {
#   "key1":"value1"  /*/*/
# }
# EOT
#     assert_equal({ "key1" => "value1" }, JSON.parse(json))
#   end
# 
#   def test_backslash
#     data = [ '\\.(?i:gif|jpe?g|png)$' ]
#     json = '["\\\\.(?i:gif|jpe?g|png)$"]'
#     assert_equal json, JSON.unparse(data)
#     assert_equal data, JSON.parse(json)
#     #
#     data = [ '\\"' ]
#     json = '["\\\\\""]'
#     assert_equal json, JSON.unparse(data)
#     assert_equal data, JSON.parse(json)
#     #
#     json = '["\/"]'
#     data = JSON.parse(json)
#     assert_equal ['/'], data
#     assert_equal json, JSON.unparse(data)
#     #
#     json = '["\""]'
#     data = JSON.parse(json)
#     assert_equal ['"'], data
#     assert_equal json, JSON.unparse(data)
#     json = '["\\\'"]'
#     data = JSON.parse(json)
#     assert_equal ["'"], data
#     assert_equal '["\'"]', JSON.unparse(data)
#   end
# 
#   def test_wrong_inputs
#     assert_raises(ParserError) { JSON.parse('"foo"') }
#     assert_raises(ParserError) { JSON.parse('123') }
#     assert_raises(ParserError) { JSON.parse('[] bla') }
#     assert_raises(ParserError) { JSON.parse('[] 1') }
#     assert_raises(ParserError) { JSON.parse('[] []') }
#     assert_raises(ParserError) { JSON.parse('[] {}') }
#     assert_raises(ParserError) { JSON.parse('{} []') }
#     assert_raises(ParserError) { JSON.parse('{} {}') }
#     assert_raises(ParserError) { JSON.parse('[NULL]') }
#     assert_raises(ParserError) { JSON.parse('[FALSE]') }
#     assert_raises(ParserError) { JSON.parse('[TRUE]') }
#     assert_raises(ParserError) { JSON.parse('[07]    ') }
#     assert_raises(ParserError) { JSON.parse('[0a]') }
#     assert_raises(ParserError) { JSON.parse('[1.]') }
#     assert_raises(ParserError) { JSON.parse('     ') }
#   end
# 
#   def test_nesting
#     assert_raises(JSON::NestingError) { JSON.parse '[[]]', :max_nesting => 1 }
#     assert_raises(JSON::NestingError) { JSON.parser.new('[[]]', :max_nesting => 1).parse }
#     assert_equal [[]], JSON.parse('[[]]', :max_nesting => 2)
#     too_deep = '[[[[[[[[[[[[[[[[[[[["Too deep"]]]]]]]]]]]]]]]]]]]]'
#     too_deep_ary = eval too_deep
#     assert_raises(JSON::NestingError) { JSON.parse too_deep }
#     assert_raises(JSON::NestingError) { JSON.parser.new(too_deep).parse }
#     assert_raises(JSON::NestingError) { JSON.parse too_deep, :max_nesting => 19 }
#     ok = JSON.parse too_deep, :max_nesting => 20
#     assert_equal too_deep_ary, ok
#     ok = JSON.parse too_deep, :max_nesting => nil
#     assert_equal too_deep_ary, ok
#     ok = JSON.parse too_deep, :max_nesting => false
#     assert_equal too_deep_ary, ok
#     ok = JSON.parse too_deep, :max_nesting => 0
#     assert_equal too_deep_ary, ok
#     assert_raises(JSON::NestingError) { JSON.generate [[]], :max_nesting => 1 }
#     assert_equal '[[]]', JSON.generate([[]], :max_nesting => 2)
#     assert_raises(JSON::NestingError) { JSON.generate too_deep_ary }
#     assert_raises(JSON::NestingError) { JSON.generate too_deep_ary, :max_nesting => 19 }
#     ok = JSON.generate too_deep_ary, :max_nesting => 20
#     assert_equal too_deep, ok
#     ok = JSON.generate too_deep_ary, :max_nesting => nil
#     assert_equal too_deep, ok
#     ok = JSON.generate too_deep_ary, :max_nesting => false
#     assert_equal too_deep, ok
#     ok = JSON.generate too_deep_ary, :max_nesting => 0
#     assert_equal too_deep, ok
#   end
# 
#   def test_load_dump
#     too_deep = '[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]'
#     assert_equal too_deep, JSON.dump(eval(too_deep))
#     assert_kind_of String, Marshal.dump(eval(too_deep))
#     assert_raises(ArgumentError) { JSON.dump(eval(too_deep), 19) }
#     assert_raises(ArgumentError) { Marshal.dump(eval(too_deep), 19) }
#     assert_equal too_deep, JSON.dump(eval(too_deep), 20)
#     assert_kind_of String, Marshal.dump(eval(too_deep), 20)
#     output = StringIO.new
#     JSON.dump(eval(too_deep), output)
#     assert_equal too_deep, output.string
#     output = StringIO.new
#     JSON.dump(eval(too_deep), output, 20)
#     assert_equal too_deep, output.string
#   end
end
