require 'test_helper'

class UseragentRunsControllerTest < ActionController::TestCase
  setup do
    @useragent_run = useragent_runs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:useragent_runs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create useragent_run" do
    assert_difference('UseragentRun.count') do
      post :create, :useragent_run => @useragent_run.attributes
    end

    assert_redirected_to useragent_run_path(assigns(:useragent_run))
  end

  test "should show useragent_run" do
    get :show, :id => @useragent_run.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @useragent_run.to_param
    assert_response :success
  end

  test "should update useragent_run" do
    put :update, :id => @useragent_run.to_param, :useragent_run => @useragent_run.attributes
    assert_redirected_to useragent_run_path(assigns(:useragent_run))
  end

  test "should destroy useragent_run" do
    assert_difference('UseragentRun.count', -1) do
      delete :destroy, :id => @useragent_run.to_param
    end

    assert_redirected_to useragent_runs_path
  end
end
