require 'helper'

class TestServer < Test::Unit::TestCase
  should "return the default domain" do
    assert_not_nil NIS::yp_get_default_domain()
  end

  context "The NIS server (default domain)" do
    setup do
      @domain = NIS::yp_get_default_domain()
    end

    should "return a result on yp_match with the current user" do
      user = ENV['USER']
      result = NIS::yp_match(@domain, "passwd.byname", user)
      assert_not_nil result
      values = result.split(":")
      assert_equal user, values[0]
      assert values.length > 1
    end

    should "not return a result on yp_match with an inexisting user" do
      user = "thisisreallynotausernameihope"
      exception = assert_raise(NIS::YPError) { result = NIS::yp_match(@domain, "passwd.byname", user) }
      assert_equal NIS::YPERR_KEY, exception.code
    end
  end
end
