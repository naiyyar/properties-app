require 'test_helper'

class ManagementCompaniesControllerTest < ActionController::TestCase
  setup do
    @management_company = management_companies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:management_companies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create management_company" do
    assert_difference('ManagementCompany.count') do
      post :create, management_company: { building_id: @management_company.building_id, name: @management_company.name, website: @management_company.website }
    end

    assert_redirected_to management_company_path(assigns(:management_company))
  end

  test "should show management_company" do
    get :show, id: @management_company
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @management_company
    assert_response :success
  end

  test "should update management_company" do
    patch :update, id: @management_company, management_company: { building_id: @management_company.building_id, name: @management_company.name, website: @management_company.website }
    assert_redirected_to management_company_path(assigns(:management_company))
  end

  test "should destroy management_company" do
    assert_difference('ManagementCompany.count', -1) do
      delete :destroy, id: @management_company
    end

    assert_redirected_to management_companies_path
  end
end
