# HyperAQ
A step toward a complete Hyperloop version of Aquarius lawn sprinkler rails app

This is the Hyperloop version of a previous Rails application, called Aquarius. Aquarius is functional and is in production, hosted on a Raspberry PI3, and servicing the 5 valves that comprise my home watering system.

Theory of Operation

Scheduling of lawn sprinklers is a calendar operation, such as "Turn on valve n every Tuesday at 10:00 am, for 12 minutes".  So, we create a Sprinkle model.  Each sprinkle has a time_input attribute, such as "Tue 10:00 am", a duration attribute, such as "12", and a valve attribute, valve_id, which identifies one of 5 Valve model objects associated with this Sprinkle model instance.

The Valve model is quite simple, it contains a name field, such as "Front Yard", and a GPIO pin number, which identifies which RPI GPIO pin is wired to the "Front Yard" valve.  Each valve can have many sprinkles.  In addition, I added fields to this model to help document the actual wiring that needed to be done in order to connect the valve to the Raspberry PI host, but this is not of any general interest.

Main Start/Stop

In order to manage the overall operation of the system, there is a single instance of a WaterManager model.  It contains a 'state' attribute, which can be the string "Active" or "Standby".  When the state is set to "Active", the entire system is readied for business.  In "Standby" mode, all calendaring activities are suspended, but manual valve operation is still enabled.

Valve Control

Controlling a valve involves accessing the associated GPIO pin, setting it to output mode, and then writing a '1' to the pin to turn on the valve, and a '0' to turn it off.  The WiringPi "GPIO Interface library for the Raspberry Pi" (http://wiringpi.com/download-and-install/) is installed on the host system, external to this Rails app.  It is accessed indirectly, using the system() primitive to access GPIO as a linux command line program. This type of access is used in order to make it convenient to develop this software package on a host development machine, which does not have access to the GPIO command, but instead has a simulated command, GPIO, which accepts expected GPIO input, and simply logs that information to a log file. See the files lib/tasks/gpio_sim.sh, and lib/tasks/install-gpio-simulator.sh for implementation details.

Scheduling

Instances of the Sprinkle model are designed to repeat on a weekly basis.  This is a hardcoded assumption.  So, scheduling consists of enumerating all of the valve state transitions needed to build out a complete weekly schedule.  At present, there is no UI provided to create a weekly watering schedule.  Instead, the application 'db/seeds.rb' file contains a series of model creations embedded within loops that provide control of 'day of the week', and 'am/pm', so that a complete production sprinkling calendar can be done before the rails server is started.  It is a future plan to add a Scheduling UI panel to provide sprinkle setup from the UI.

Logging History

As valves get turned on and off by sprinkle events, it is important to log that operation so that a complete history of valve behavior is recorded, so a History model is created for this purpose.  It is very simple containing a start timestamp, and a stop timestamp, along with a reference to the valve being manipulated. A History record belongs_to a Valve.

Implementation details

After a few attempts with doing scheduling by running background processes alongside the server, and having that process sleep until the next scheduled sprinkle occurs, and then post an http request back into the server, and then schedule another process, ad infinitum, I looked for a more elegant solution.  I wanted a solution that was less procedural and more declarative.  I also wanted a solution that would be able to continue after a complete system shutdown/restart sequence.  I chose to map each Sprinkle activity into a pair of weekly crontab entries, an 'on' and an 'off'.  Each crontab entry would post an http request back to the rails server, requesting an update against an aggregate model, called ScheduledSprinkleEvent.  This model simply enumerates the sprinkle_id and the valve command state on an http PATCH request.  Within the scope of this event, the valve can be fetched from the sprinkle_id, and the command is sent to the valve.  If the cmd is 'on (1)', A new History object is created, identifying the Valve used and the start time.  The history_id attribute of the ScheduledSprinkleEvent is stashed in the database.  If the cmd is 'off (0)', then the History object is updated with the stop time. All ScheduledSprinkleEvent records are created once in the seeds.rb file, one per Valve, and are then used repeatedly for state saving between on and off events.

ServerOps

Here is a list of ServerOp components that must be implemented in order to complete all of the logic to hook up back end functionality.  More details can be found as commentary within each file.

fetch_hostname.rb

fetch_portnumber.rb

load_crontab.rb

unload_crontab.rb

scheduled_sprinkle_event_activate.rb

scheduled_sprinkle_event_deactivate.rb

valve_activate.rb

valve_deactivate.rb


Futures 

I want to move to a prettier web display, and I also want to provide push buttons for:

System change from Standby to Active

Manual override of valve operations, making it easy to start/stop each valve by pushing a labelled button.

Automatic update of a Sprinkle table, sorted with the next scheduled sprinkle record at the top.

Automatic update of a History table, sorted with the latest history record at the top.

Highlighting of the above table records which are currently active.

I offer this app as an example of a simple Rails app, extended to use Hyperloop Isomorphic framework, to demonstrate how a web app can be implemented completely in Ruby/Opal compilers so that development and support is simplified. 

Software is complex. Less complexity in software development is a Good Thing.

This repo is a work-in-process, more work is necessary to deploy Operations, particularly the ServerOp, so that the necessary back-end work of cycling valves and crontab files can be made to work within a Hyperloop/Rails implementation.

And, I can always make the README.md more accurate, complete, and prettier.

Application SETUP

    bundle install      #to load the gems needed by the app.

    sh dev-bounce-db.sh #to dump the database, create it, 
                        #and add the contents of the seeds.rb file to the database.

    rails s 

access http://localhost:3000 in your browser.

All you can do now is click the buttons and view the test sprinkle and history data.
