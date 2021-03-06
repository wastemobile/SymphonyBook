#!/bin/bash

# Symphony No.5 Command Line Tool
# Homepage: http://github.com/firegoby/symphonyno5.sh.git
# Author: Chris Batchelor (http://firegoby.com/)
# License: Unlicense (http://unlicense.org)

usage() {
  scriptname=`basename $0`
  echo "Symphony No.5 Usage"
  echo ""
  echo "Create new project"
  echo "    $scriptname new projectname"
  echo ""
  echo "Update/install git submodules from extensions.csv"
  echo "    $scriptname extensions"
  echo ""
  echo "Set manifest & workspace directories' file permissions"
  echo "    $scriptname setperms 0775 0664"
  echo ""
  echo "Fix permissions - set manifest & workspace permission to those defined in manifest/config.php"
  echo "    $scriptname fixperms"
}

verifySymphonyRoot() {
  if [ ! -e index.php -a ! -d symphony ]
  then
    echo "Error: It doesn't look like you're in the root directory of a Symphony project! Aborting."
    exit 1
  fi
}

extensions() {
  verifySymphonyRoot
  filename="extensions.csv"
  if [ -f $filename ] 
  then
    while IFS="," read one two
    do
      git submodule add "$one" "$two"
    done < "$filename"
    git submodule update --init
  else
    echo "Error: Can't find an extensions.csv file! Aborting."
  fi
}

setperms() {
  verifySymphonyRoot
  echo "Setting manifest directory permissions to $1"
  find manifest.* -type d -exec chmod $1 {} \;
  echo "Setting workspace directory permissions to $1"
  find workspace -type d -exec chmod $1 {} \;
  echo "Setting manifest file permissions to $2"
  find manifest.* -type f -exec chmod $2 {} \;
  echo "Setting workspace file permissions to $2"
  find workspace -type f -exec chmod $2 {} \;
}

fixperms() {
  verifySymphonyRoot
  fileperms=`awk '/file/ {getline;print substr($0, length-5, 4)}' manifest/config.php`
  dirperms=`awk '/directory/ {getline;print substr($0, length-5, 4)}' manifest/config.php`
  setperms $dirperms $fileperms
}

new(){
  project="$1"
  read -p "Have you created your MySQL database and setup your web server (y/n)? " -n 1
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    echo ""
    echo "Creating new Symphony: $project"
    git clone -b master --depth 1 git://github.com/firegoby/symphonyno5.git $project
    cd $project
    echo "Removing Symphony No.5 git history"
    rm -rf .git
    echo "Loosening file permissions for install"
    chmod 777 symphony .
    chmod -R 777 workspace
    echo "Creating fresh git repository"
    git init
    echo "Cloning extensions and extras as git submodules from extensions.csv"
    extensions
    echo "Creating manifest symlink to manifest.dev folder"
    ln -s manifest.dev manifest
    echo "*********************************"
    echo "Open http://yourdomain.com/install in your browser and follow the installation instructions."
    echo "Return here once you've successfully logged into the Symphony Admin..."
    read -p "Continue (y/n) " -n 1
    if [[ $REPLY =~ ^[Nn]$ ]]
    then
      echo ""
      echo "Aborting."
      exit 1
    elif [[ $REPLY =~ ^[Yy]$ ]]
    then
      echo ""
      read -p "Do you want to remove the README and LICENSE files? (y/n) " -n 1
      if [[ $REPLY =~ ^[Yy]$ ]]
      then
        echo ""
        echo "Removing README and LICENSE files"
        rm README.* LICENSE.*
      fi
      if [ ! -f manifest.prod/config.php ]
      then
        echo "Copying manifest.dev/config.php to manifest.prod"
        cp manifest.dev/config.php manifest.prod/config.php
      fi
      if [ -d install ]
      then
        echo "Removing installation files"
        rm -rf install
      fi
      fileperms=`awk '/file/ {getline;print substr($0, length-5, 4)}' manifest/config.php`
      dirperms=`awk '/directory/ {getline;print substr($0, length-5, 4)}' manifest/config.php`
      echo "Setting root directory permissions to $dirperms"
      chmod $dirperms .
      echo "Setting root files permissions to $fileperms"
      find . -type f -maxdepth 1 -exec chmod $fileperms {} \;
      echo "Setting Symphony directory permissions to $dirperms"
      find symphony -type d -exec chmod $dirperms {} \;
      echo "Setting Symphony file permissions to $fileperms"
      find symphony -type f -exec chmod $fileperms {} \;
      fixperms
      echo "Adding Project files for initial commit"
      git add .
      echo "Creating initial commit"
      git commit -m "Initial commit"
      echo "Creating & switching to branch 'develop' from branch 'master'"
      git checkout -b develop
      echo "*********************************"
      echo ""
      echo "Bravo! Bravo! Your new Symphony '$project' has been created!"
      echo ""
      echo "'cd $project' to get started..."
      exit 0
    fi
  else
    echo ""
    echo "Before you continue you will need to..."
    echo "* create a MySQL database (recommend charset utf-8)"
    echo "* create a username and password to connect to MySQL with"
    echo "* setup your webserver (usually Apache) to serve your domain from `pwd`/$project"
  fi
}

cmd=$1
case $cmd in
        new) new $2;;
 extensions) extensions;;
   setperms) setperms $2 $3;;
   fixperms) fixperms;;
          *) usage
esac
