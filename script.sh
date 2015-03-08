#!/bin/bash

cd ~/sanro-inventory
bundle install
rake db:migrate
rails s
exit 0
