#!/bin/bash
#
# drop and recreate the database, applying all of the migrations, load the database with seed data
#
RAILS_ENV=development rake db:drop 
RAILS_ENV=development rake db:create 
RAILS_ENV=development rake db:migrate 
RAILS_ENV=development rake db:seed

