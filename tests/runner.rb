#!/usr/local/bin/ macruby
require File.join(File.dirname(__FILE__), "..", "json")
require 'test/unit/ui/console/testrunner'
require 'test/unit/testsuite'
# p JSON.load(['a', 'b', 'c'].to_json)
# p JSON.generate [1, 2, {"a"=>3.141}, false, true, nil, 4..10] == "[1,2,{\"a\":3.141},false,true,null,\"4..10\"]"

require File.join(File.dirname(__FILE__), "test_json")
# p JSON.load "{\"_id\":\"compound-synthesis-123562176428057\",\"_rev\":\"3225026046\",\"name\":\"Compound Synthesis\",\"sub_categories\":[\"compound-2-123562185648062\"],\"couchrest-type\":\"Category\",\"_revs_info\":[{\"rev\":\"3225026046\",\"status\":\"available\"},{\"rev\":\"4197510875\",\"status\":\"available\"},{\"rev\":\"1533305651\",\"status\":\"available\"}]}\n"