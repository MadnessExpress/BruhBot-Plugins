#!/bin/bash

if [ "$1" = "restart" ]; then
	echo "#########Restarting############"
	echo "###############################"
  ./bot.rb
elif [ "$1" = "update" ]; then
	git pull
  cd plugins
  git pull
  cd ../
	./bot.rb
else
	echo "Nothing happened."
fi
