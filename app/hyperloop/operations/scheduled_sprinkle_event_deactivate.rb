# /app/hyperloop/operations/scheduled_sprinkle_event_deactivate.rb

# * input param: a params hash.

# This operation is invoked from a standard rails controller, as the result of receiving a ScheduledSprinkleEvent.
# The request contains the id of the scheduled_sprinkle_event, the id of a sprinkle, and the cmd field of a valve.
# The sprinkle is fetched in order to access the valve that it belongs to, and then do the following:
  
#   * Fetch the ScheduledSprinkleEvent record from the database, given the scheduled_sprinkle_id parameter passed in the request.

#   * Fetch the Sprinkle record from the database, given the parameter sprinkle_id parameter passed in the request.

#   * Fetch the Valve record from the database, given the parameter valve_id parameter in the request.

#   * Set the state attribute of the sprinkle to 'active' in the database. Save it.  This will cause the background of the sprinkle
#     displayed in the table to get highlighted.

#   * Fetch the History record from the ScheduledSprinkleEvent record, filling in the stop_time and valve_id fields.  Save it. 
#     This will cause the existing incomplete History to get updated and re-displayed with a modified visual style.  
#     It is marked 'done' by the UI because it is now complete.

#   * Clear history_id field of the current ScheduledSprinkleEvent, and save it.

#   * Locate the valve from the valve id, and call its stop method.

#   * Ensure that all the fields of the ScheduledSprinkleEvent record have been updated, and then save it.

#   * All done.

class ScheduledSprinkleEventDeactivate < Hyperloop::ServerOp
end


