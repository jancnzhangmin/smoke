require 'test_helper'

class MytestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mytest = mytests(:one)
  end

  test "should get index" do
    get mytests_url
    assert_response :success
  end

  test "should get new" do
    get new_mytest_url
    assert_response :success
  end

  test "should create mytest" do
    assert_difference('Mytest.count') do
      post mytests_url, params: { mytest: { test: @mytest.test } }
    end

    assert_redirected_to mytest_url(Mytest.last)
  end

  test "should show mytest" do
    get mytest_url(@mytest)
    assert_response :success
  end

  test "should get edit" do
    get edit_mytest_url(@mytest)
    assert_response :success
  end

  test "should update mytest" do
    patch mytest_url(@mytest), params: { mytest: { test: @mytest.test } }
    assert_redirected_to mytest_url(@mytest)
  end

  test "should destroy mytest" do
    assert_difference('Mytest.count', -1) do
      delete mytest_url(@mytest)
    end

    assert_redirected_to mytests_url
  end
end
