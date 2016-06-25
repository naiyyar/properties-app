require 'test_helper'

class RentalPriceHistoriesControllerTest < ActionController::TestCase
  setup do
    @rental_price_history = rental_price_histories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rental_price_histories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rental_price_history" do
    assert_difference('RentalPriceHistory.count') do
      post :create, rental_price_history: {  }
    end

    assert_redirected_to rental_price_history_path(assigns(:rental_price_history))
  end

  test "should show rental_price_history" do
    get :show, id: @rental_price_history
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rental_price_history
    assert_response :success
  end

  test "should update rental_price_history" do
    patch :update, id: @rental_price_history, rental_price_history: {  }
    assert_redirected_to rental_price_history_path(assigns(:rental_price_history))
  end

  test "should destroy rental_price_history" do
    assert_difference('RentalPriceHistory.count', -1) do
      delete :destroy, id: @rental_price_history
    end

    assert_redirected_to rental_price_histories_path
  end
end
