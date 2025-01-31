#!/bin/bash
#

# Prepare the workspace files with the values from the devcontainer.env file
set -a
source $workspaceFolder/.devcontainer/.env

echo ">>> Development Setup"
sudo apt-get update

# VSCode debugger profile
mkdir -p .vscode && cp .devcontainer/launch.json .vscode/launch.json

envsubst < $workspaceFolder/.devcontainer/my.cnf > /home/vscode/.my.cnf

# Make the workspace directory the docroot
echo ">>> Symlink $DocumentRoot to $workspaceFolder"
sudo rm -rf $DocumentRoot
sudo ln -fs $workspaceFolder $DocumentRoot
sudo chgrp -R www-data /var/www

echo 'error_reporting=0' | sudo tee /usr/local/etc/php/conf.d/no-warn.ini

# Create docker image files
sudo mkdir -p /usr/src/friendica/config
sudo cp $workspaceFolder/.devcontainer/docker/config/*.php /usr/src/friendica/config/
sudo cp $workspaceFolder/VERSION /usr/src/friendica/

sudo mkdir -p $workspaceFolder/addon
bin/composer.phar --no-dev install

# Set proper permissions
sudo chown -R $developmentUser:www-data $workspaceFolder
sudo chmod -R g=u $workspaceFolder

exit 0
