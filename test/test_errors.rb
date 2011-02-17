require 'helper'

class TestErrors < Test::Unit::TestCase
  should "Return error string with yperr_string" do
    assert_equal "RPC failure on NIS operation", NIS::yperr_string(NIS::YPERR_RPC)
    assert_equal "Internal NIS error", NIS::yperr_string(NIS::YPERR_YPERR)
  end

  should "Raise YPError when server doesn't exist" do
    exception = assert_raise(NIS::YPError) { NIS::yp_match("foo.example.org", "passwd.byname", "foo") }
    assert_equal NIS::YPERR_YPERR, exception.code
    assert_equal "Internal NIS error", exception.message
  end
end
