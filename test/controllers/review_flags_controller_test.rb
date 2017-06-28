require 'test_helper'

class ReviewFlagsControllerTest < ActionController::TestCase
  setup do
    @review_flag = review_flags(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:review_flags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create review_flag" do
    assert_difference('ReviewFlag.count') do
      post :create, review_flag: {  }
    end

    assert_redirected_to review_flag_path(assigns(:review_flag))
  end

  test "should show review_flag" do
    get :show, id: @review_flag
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @review_flag
    assert_response :success
  end

  test "should update review_flag" do
    patch :update, id: @review_flag, review_flag: {  }
    assert_redirected_to review_flag_path(assigns(:review_flag))
  end

  test "should destroy review_flag" do
    assert_difference('ReviewFlag.count', -1) do
      delete :destroy, id: @review_flag
    end

    assert_redirected_to review_flags_path
  end
end
