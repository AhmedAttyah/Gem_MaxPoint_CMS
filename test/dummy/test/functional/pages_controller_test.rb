require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  def test_get_home
    get :home
    refute_response :success
  rescue ActionController::RoutingError => e
    # This test should currently throw ActionController::RoutingError since
    # there are no pages yet.
  else
    fail 'Please update this test to reflect the new changes.'
  end
end
