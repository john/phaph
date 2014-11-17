#!/usr/bin/env bash

# Checking if RVM is installed
if ! [ -d "~/.rvm" ]; then
    echo "Installing RVM..."
    gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
    \curl -sSL https://get.rvm.io | bash -s stable --autolibs=4 --ruby
    source ~/.rvm/scripts/rvm
    echo "source ~/.rvm/scripts/rvm" >> ~/.bashrc
else
    echo "Updating RVM..."
    rvm get stable
fi;

# echo -n "RVM version is: "
# rvm --version

echo "Installing Ruby..."
rvm install ruby-2.1.5

echo "Making installed Ruby the default one..."
rvm use ruby --default

echo "Installing latest version of Ruby Gems..."
rvm rubygems current

gem install daemon_controller