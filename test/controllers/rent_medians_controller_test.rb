require 'test_helper'

class RentMediansControllerTest < ActionController::TestCase
  setup do
    @rent_median = rent_medians(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rent_medians)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rent_median" do
    assert_difference('RentMedian.count') do
      post :create, rent_median: {  }
    end

    assert_redirected_to rent_median_path(assigns(:rent_median))
  end

  test "should show rent_median" do
    get :show, id: @rent_median
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rent_median
    assert_response :success
  end

  test "should update rent_median" do
    patch :update, id: @rent_median, rent_median: {  }
    assert_redirected_to rent_median_path(assigns(:rent_median))
  end

  test "should destroy rent_median" do
    assert_difference('RentMedian.count', -1) do
      delete :destroy, id: @rent_median
    end

    assert_redirected_to rent_medians_path
  end
end
