require 'test_helper'

class ScheduledSprinkleEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @scheduled_sprinkle_event = scheduled_sprinkle_events(:one)
  end

  test "should get index" do
    get scheduled_sprinkle_events_url
    assert_response :success
  end

  test "should get new" do
    get new_scheduled_sprinkle_event_url
    assert_response :success
  end

  test "should create scheduled_sprinkle_event" do
    assert_difference('ScheduledSprinkleEvent.count') do
      post scheduled_sprinkle_events_url, params: { scheduled_sprinkle_event: { history_id: @scheduled_sprinkle_event.history_id, sprinkle_id: @scheduled_sprinkle_event.sprinkle_id, valve_cmd: @scheduled_sprinkle_event.valve_cmd, valve_id: @scheduled_sprinkle_event.valve_id } }
    end

    assert_redirected_to scheduled_sprinkle_event_url(ScheduledSprinkleEvent.last)
  end

  test "should show scheduled_sprinkle_event" do
    get scheduled_sprinkle_event_url(@scheduled_sprinkle_event)
    assert_response :success
  end

  test "should get edit" do
    get edit_scheduled_sprinkle_event_url(@scheduled_sprinkle_event)
    assert_response :success
  end

  test "should update scheduled_sprinkle_event" do
    patch scheduled_sprinkle_event_url(@scheduled_sprinkle_event), params: { scheduled_sprinkle_event: { history_id: @scheduled_sprinkle_event.history_id, sprinkle_id: @scheduled_sprinkle_event.sprinkle_id, valve_cmd: @scheduled_sprinkle_event.valve_cmd, valve_id: @scheduled_sprinkle_event.valve_id } }
    assert_redirected_to scheduled_sprinkle_event_url(@scheduled_sprinkle_event)
  end

  test "should destroy scheduled_sprinkle_event" do
    assert_difference('ScheduledSprinkleEvent.count', -1) do
      delete scheduled_sprinkle_event_url(@scheduled_sprinkle_event)
    end

    assert_redirected_to scheduled_sprinkle_events_url
  end
end
