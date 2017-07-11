#!/bin/bash
#
# precompile assets prior to production deploy
#
touch log/application.log
rm log/application.log
touch log/development.log
rm log/development.log
bundle update
sh dev-bounce-db.sh
sh dev-start.sh 
