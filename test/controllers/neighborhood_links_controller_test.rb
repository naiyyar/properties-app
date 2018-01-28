require 'test_helper'

class NeighborhoodLinksControllerTest < ActionController::TestCase
  setup do
    @neighborhood_link = neighborhood_links(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:neighborhood_links)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create neighborhood_link" do
    assert_difference('NeighborhoodLink.count') do
      post :create, neighborhood_link: {  }
    end

    assert_redirected_to neighborhood_link_path(assigns(:neighborhood_link))
  end

  test "should show neighborhood_link" do
    get :show, id: @neighborhood_link
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @neighborhood_link
    assert_response :success
  end

  test "should update neighborhood_link" do
    patch :update, id: @neighborhood_link, neighborhood_link: {  }
    assert_redirected_to neighborhood_link_path(assigns(:neighborhood_link))
  end

  test "should destroy neighborhood_link" do
    assert_difference('NeighborhoodLink.count', -1) do
      delete :destroy, id: @neighborhood_link
    end

    assert_redirected_to neighborhood_links_path
  end
end
