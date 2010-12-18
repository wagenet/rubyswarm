require 'test_helper'

class ClientRunsControllerTest < ActionController::TestCase
  setup do
    @client_run = client_runs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:client_runs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create client_run" do
    assert_difference('ClientRun.count') do
      post :create, :client_run => @client_run.attributes
    end

    assert_redirected_to client_run_path(assigns(:client_run))
  end

  test "should show client_run" do
    get :show, :id => @client_run.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @client_run.to_param
    assert_response :success
  end

  test "should update client_run" do
    put :update, :id => @client_run.to_param, :client_run => @client_run.attributes
    assert_redirected_to client_run_path(assigns(:client_run))
  end

  test "should destroy client_run" do
    assert_difference('ClientRun.count', -1) do
      delete :destroy, :id => @client_run.to_param
    end

    assert_redirected_to client_runs_path
  end
end
