#!/usr/bin/env bash

# Checking if RVM is installed
if ! [ -d "~/.rvm" ]; then
    echo "Installing RVM..."
    \curl -sSL https://get.rvm.io | bash -s stable
    source ~/.rvm/scripts/rvm
    echo "source ~/.rvm/scripts/rvm" >> ~/.bashrc
else
    echo "Updating RVM..."
    rvm get stable
fi;

echo -n "RVM version is: "
rvm --version

echo "Installing Ruby..."
rvm install ruby

echo "Making installed Ruby the default one..."
rvm use ruby --default

echo "Installing latest version of Ruby Gems..."
rvm rubygems current