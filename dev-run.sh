#!/bin/bash
#
# precompile assets prior to production deploy
#
rm log/application.log
rm log/development.log
bundle update
sh dev-bounce-db.sh
sh dev-start.sh 
