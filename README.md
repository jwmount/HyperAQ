# HyperAQ

This is the Hyperloop version of the Aquarius sprinkler server.

Models

  * Valve

    This is the fundamental object of this app.  There are 5 valves under management.  Each valve has 3 key attributes: name, command_state, and GPIO pin number.

  * Sprinkle

    A Sprinkle is a calendar object; it identifies a valve, a 'time input' field, such as 'Tue 9:48', and a duration field in minutes.  Sprinkles are mapped into the system crontab, with a crontab entry for each Sprinkle-on and Sprinkle-off.  Sprinkles are weekly objects, so a daily valve sprinkle would be made up of 7 Sprinkle records.

  * History

    Histories are simple logging objects.  Each History is owned by a Valve, and has two time states: start and stop.  When a Valve goes on, a History object is created with a start time set.  When that Valve goes off, the history object is updated with a stop time and saved for display purposes.

  * WaterManager
  
    WaterManager is a singleton, and acts as the manager of the sprinkling schedule.  When the 'Standby' button on the nav bar is pushed, the WaterManager requests the WaterManagerServer, a ServerOp, to build a new crontab from the sprinkles and activate the system for scheduled sprinkling.

  * Porter

Components

  * Top Level
    App
    * Navbar
      * PorterStatus
      * WaterStatus
      * ValveButtons
        * ValveButton
    * Layout
      * SprinkleList
        * SpinkleRow
      * HistoryList
        * HistoryRow

