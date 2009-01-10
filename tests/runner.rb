#!/usr/local/bin/ macruby
require File.join(File.dirname(__FILE__), "..", "json")
require 'test/unit/ui/console/testrunner'
require 'test/unit/testsuite'
p JSON.load(['a', 'b', 'c'].to_json)

JSON.generate [1, 2, {"a"=>3.141}, false, true, nil, 4..10] == "[1,2,{\"a\":3.141},false,true,null,\"4..10\"]"
