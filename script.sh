#!/bin/bash

cd /home/paul/sanro-inventory
bundle install
rake db:migrate
rails s
exit 0
