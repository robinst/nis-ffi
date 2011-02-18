require 'helper'

class TestErrors < Test::Unit::TestCase
  should "return error string with yperr_string" do
    assert_match /^RPC failure/, NIS::yperr_string(NIS::YPERR_RPC)
    assert_match /error/, NIS::yperr_string(NIS::YPERR_YPERR)
  end

  should "raise YPError when server doesn't exist" do
    exception = assert_raise(NIS::YPError) { NIS::yp_match("foo.example.org", "passwd.byname", "foo") }
    assert [NIS::YPERR_YPERR, NIS::YPERR_DOMAIN].include?(exception.code)
    assert_equal NIS::yperr_string(exception.code), exception.message
  end
end
