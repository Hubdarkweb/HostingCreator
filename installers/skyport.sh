#!/bin/bash
set -e
# Function to display messages
echo_message() {
    echo -e "\033[1;32m$1\033[0m"
}

echo_message "Do you want to install the panel? (yes/no)"
read answer

if [ "$answer" != "yes" ]; then
    echo_message "Installation aborted."
    exit 0
fi

echo_message "* Installing Dependencies"

# Update package list and install dependencies
sudo apt update
sudo apt install -y curl software-properties-common
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install nodejs -y 
sudo apt install git -y

echo_message "* Installed Dependencies"

echo_message "* Installing Files"

# Create directory, clone repository, and install files
mkdir -p skyport
cd skyport || { echo_message "Failed to change directory to skyport"; exit 1; }
git clone https://github.com/Hubdarkweb/panel5.git
cd panel5 || { echo_message "Failed to change directory to panel"; exit 1; }
npm install

echo_message "* Installed Files"

# Prompt for user details
echo_message "Please enter the username:"
read username
echo_message "Please enter the email:"
read email
echo_message "Please enter the password:"
read password  # -s flag for silent input

echo_message "* Starting Skyport"

# Run setup scripts
npm run seed
npm run createUser -- --username="$username" --email="$email" --password="$password"

echo_message "* Starting Skyport With PM2"

# Install PM2 and start the application
sudo npm install -g pm2
pm2 start index.js

echo_message "* Skyport Installed and Started on Port 3001"
