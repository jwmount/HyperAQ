# /app/hyperloop/operations/scheduled_sprinkle_event_activate.rb

# * input param: a params hash.

# This operation is invoked from a standard rails controller, as the result of receiving a ScheduledSprinkleEvent.
# The request contains the id of the scheduled_sprinkle_event, the id of a sprinkle, and the cmd field of a valve.
# The sprinkle is fetched in order to access the valve that it belongs to, and then do the following:
  
#   * Fetch the ScheduledSprinkleEvent record from the database, given the scheduled_sprinkle_id parameter passed in the request.

#   * Fetch the Sprinkle record from the database, given the parameter sprinkle_id parameter passed in the request.

#   * Fetch the Valve record from the database, given the parameter valve_id parameter in the request.

#   * Set the state attribute of the sprinkle to 'active' in the database. Save it.  This will cause the background of the sprinkle
#     displayed in the table to get highlighted.

#   * Create a new instance of a History, filling in the start_time and valve_id fields.  Save it. 
#     This will cause the new History to get added to the display and highlighted.  
#     It is marked 'active' by the UI because it is incomplete, it has a start_time, but not a stop_time.

#   * Put the id of the new History record into the ScheduledSprinkleEvent history_id field, and save it.

#   * Locate the valve from the valve id, and call its start method.

#   * Ensure that all the fields of the ScheduledSprinkleEvent record have be updated, and then save it.

#   * All done.

class ScheduledSprinkleEventActivate < Hyperloop::ServerOp
end


