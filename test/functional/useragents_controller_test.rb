require 'test_helper'

class UseragentsControllerTest < ActionController::TestCase
  setup do
    @useragent = useragents(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:useragents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create useragent" do
    assert_difference('Useragent.count') do
      post :create, :useragent => @useragent.attributes
    end

    assert_redirected_to useragent_path(assigns(:useragent))
  end

  test "should show useragent" do
    get :show, :id => @useragent.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @useragent.to_param
    assert_response :success
  end

  test "should update useragent" do
    put :update, :id => @useragent.to_param, :useragent => @useragent.attributes
    assert_redirected_to useragent_path(assigns(:useragent))
  end

  test "should destroy useragent" do
    assert_difference('Useragent.count', -1) do
      delete :destroy, :id => @useragent.to_param
    end

    assert_redirected_to useragents_path
  end
end
