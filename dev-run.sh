#!/bin/bash
#
# precompile assets prior to production deploy
#
rm log/*.log
bundle update
sh dev-bounce-db.sh
#  sh dev-start.sh 
rails s
