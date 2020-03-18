require 'test_helper'

class PastListingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get past_listings_index_url
    assert_response :success
  end

  test "should get edit" do
    get past_listings_edit_url
    assert_response :success
  end

  test "should get update" do
    get past_listings_update_url
    assert_response :success
  end

  test "should get destroy" do
    get past_listings_destroy_url
    assert_response :success
  end

end
