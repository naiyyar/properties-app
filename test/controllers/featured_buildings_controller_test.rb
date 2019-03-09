require 'test_helper'

class FeaturedBuildingsControllerTest < ActionController::TestCase
  setup do
    @featured_building = featured_buildings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:featured_buildings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create featured_building" do
    assert_difference('FeaturedBuilding.count') do
      post :create, featured_building: {  }
    end

    assert_redirected_to featured_building_path(assigns(:featured_building))
  end

  test "should show featured_building" do
    get :show, id: @featured_building
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @featured_building
    assert_response :success
  end

  test "should update featured_building" do
    patch :update, id: @featured_building, featured_building: {  }
    assert_redirected_to featured_building_path(assigns(:featured_building))
  end

  test "should destroy featured_building" do
    assert_difference('FeaturedBuilding.count', -1) do
      delete :destroy, id: @featured_building
    end

    assert_redirected_to featured_buildings_path
  end
end
