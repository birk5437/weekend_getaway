require 'test_helper'

class GetawaySearchesControllerTest < ActionController::TestCase
  setup do
    @getaway_search = getaway_searches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:getaway_searches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create getaway_search" do
    assert_difference('GetawaySearch.count') do
      post :create, getaway_search: { ip_address: @getaway_search.ip_address, price_limit: @getaway_search.price_limit, user_id: @getaway_search.user_id }
    end

    assert_redirected_to getaway_search_path(assigns(:getaway_search))
  end

  test "should show getaway_search" do
    get :show, id: @getaway_search
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @getaway_search
    assert_response :success
  end

  test "should update getaway_search" do
    patch :update, id: @getaway_search, getaway_search: { ip_address: @getaway_search.ip_address, price_limit: @getaway_search.price_limit, user_id: @getaway_search.user_id }
    assert_redirected_to getaway_search_path(assigns(:getaway_search))
  end

  test "should destroy getaway_search" do
    assert_difference('GetawaySearch.count', -1) do
      delete :destroy, id: @getaway_search
    end

    assert_redirected_to getaway_searches_path
  end
end
