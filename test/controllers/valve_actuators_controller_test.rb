require 'test_helper'

class ValveActuatorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @valve_actuator = valve_actuators(:one)
  end

  test "should get index" do
    get valve_actuators_url
    assert_response :success
  end

  test "should get new" do
    get new_valve_actuator_url
    assert_response :success
  end

  test "should create valve_actuator" do
    assert_difference('ValveActuator.count') do
      post valve_actuators_url, params: { valve_actuator: { cmd: @valve_actuator.cmd, valve_id: @valve_actuator.valve_id } }
    end

    assert_redirected_to valve_actuator_url(ValveActuator.last)
  end

  test "should show valve_actuator" do
    get valve_actuator_url(@valve_actuator)
    assert_response :success
  end

  test "should get edit" do
    get edit_valve_actuator_url(@valve_actuator)
    assert_response :success
  end

  test "should update valve_actuator" do
    patch valve_actuator_url(@valve_actuator), params: { valve_actuator: { cmd: @valve_actuator.cmd, valve_id: @valve_actuator.valve_id } }
    assert_redirected_to valve_actuator_url(@valve_actuator)
  end

  test "should destroy valve_actuator" do
    assert_difference('ValveActuator.count', -1) do
      delete valve_actuator_url(@valve_actuator)
    end

    assert_redirected_to valve_actuators_url
  end
end
