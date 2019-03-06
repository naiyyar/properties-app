require 'test_helper'

class FeaturedCompsControllerTest < ActionController::TestCase
  setup do
    @featured_comp = featured_comps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:featured_comps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create featured_comp" do
    assert_difference('FeaturedComp.count') do
      post :create, featured_comp: {  }
    end

    assert_redirected_to featured_comp_path(assigns(:featured_comp))
  end

  test "should show featured_comp" do
    get :show, id: @featured_comp
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @featured_comp
    assert_response :success
  end

  test "should update featured_comp" do
    patch :update, id: @featured_comp, featured_comp: {  }
    assert_redirected_to featured_comp_path(assigns(:featured_comp))
  end

  test "should destroy featured_comp" do
    assert_difference('FeaturedComp.count', -1) do
      delete :destroy, id: @featured_comp
    end

    assert_redirected_to featured_comps_path
  end
end
