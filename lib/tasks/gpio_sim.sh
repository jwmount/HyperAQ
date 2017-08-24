#!/bin/bash
#
# link this command to a terminal command of the same name
#
# simulate the following command:
# gpio -g command pin action, where
# ARGV[0] = '-g'
# ARGV[1] = command
# ARGV[2] = pin
# ARGV[3] = action
#
# Open a valve whose relay is on gpio pin 18
# GPIO simulation --> gpio -g mode 18 out
# GPIO simulation --> gpio -g write 18 1

# Close a valve whose relay is on gpio pin 14
# GPIO simulation --> gpio -g mode 14 out
# GPIO simulation --> gpio -g write 14 0

LOG_FILE="/home/$USER/development/Aquarius/log/application.log"

touch $LOG_FILE
echo "GPIO simulation --> gpio " $1 $2 $3 $4 >> $LOG_FILE
