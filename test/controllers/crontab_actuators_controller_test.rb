require 'test_helper'

class CrontabActuatorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @crontab_actuator = crontab_actuators(:one)
  end

  test "should get index" do
    get crontab_actuators_url
    assert_response :success
  end

  test "should get new" do
    get new_crontab_actuator_url
    assert_response :success
  end

  test "should create crontab_actuator" do
    assert_difference('CrontabActuator.count') do
      post crontab_actuators_url, params: { crontab_actuator: { state: @crontab_actuator.state } }
    end

    assert_redirected_to crontab_actuator_url(CrontabActuator.last)
  end

  test "should show crontab_actuator" do
    get crontab_actuator_url(@crontab_actuator)
    assert_response :success
  end

  test "should get edit" do
    get edit_crontab_actuator_url(@crontab_actuator)
    assert_response :success
  end

  test "should update crontab_actuator" do
    patch crontab_actuator_url(@crontab_actuator), params: { crontab_actuator: { state: @crontab_actuator.state } }
    assert_redirected_to crontab_actuator_url(@crontab_actuator)
  end

  test "should destroy crontab_actuator" do
    assert_difference('CrontabActuator.count', -1) do
      delete crontab_actuator_url(@crontab_actuator)
    end

    assert_redirected_to crontab_actuators_url
  end
end
