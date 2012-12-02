#!/bin/bash

# Symphony No.5 Command Line Tool
# Homepage: http://github.com/firegoby/symphonyno5.sh.git
# Author: Chris Batchelor (http://firegoby.com/)
# License: Unlicense (http://unlicense.org)

usage() {
  scriptname=`basename $0`
  echo "Symphony No.5 使用方法"
  echo ""
  echo "建立新開發專案"
  echo "    $scriptname new projectname"
  echo ""
  echo "根據 extensions.csv 更新/安裝 git submodules"
  echo "    $scriptname extensions"
  echo ""
  echo "編譯所有前端資源 (Scripts 與 Styles)"
  echo "    $scriptname compile"
  echo ""
  echo "編譯 Coffescript 與 Javascript (Google Closure minify)"
  echo "    $scriptname compile scripts"
  echo ""
  echo "編譯 CSS (支援 Less, Sass 或 Stylus)"
  echo "    $scriptname compile styles"
  echo ""
  echo "設置 manifest 與 workspace 目錄的檔案權限"
  echo "    $scriptname setperms 0775 0664"
  echo ""
  echo "修復權限 - 根據 manifest/config.php 設置 manifest 與 workspace 的檔案權限"
  echo "    $scriptname fixperms"
}

verifySymphonyRoot() {
  if [ ! -e index.php -a ! -d symphony ]
  then
    echo "錯誤： 似乎您並不在一個 Symphony 專案的根目錄下！指令終止。"
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
    echo "錯誤：找不到 extensions.csv 檔案！指令終止。"
  fi
}

compile() {
  verifySymphonyRoot
  case $1 in
    scripts) compilescripts;;
    styles) compilestyles;;
    *) compilescripts
      compilestyles;;
  esac
}

compilescripts() {
  compilecoffeescripts
  concatscripts workspace/scripts/production.js
  closurecompilejs workspace/scripts/production.js workspace/scripts/production.min.js
  if [ $? -eq 0 ]
  then
    cd workspace/scripts
    rm production-*.min.js
    echo "Removed old production-SHA1.min.js files"
    newsha=`shasum production.min.js | awk '{print substr($0,0,10)}'`
    mv production.min.js production-${newsha}.min.js
    echo "Moved production.min.js to SHA1 tagged 'production-$newsha.min.js'"
    sed -i '' "s|production-[a-f0-9]*\.min\.js|production-$newsha.min.js|" ../utilities/master.xsl
    echo "Updated master.xsl with new production-$newsha.min.js"
    # return to root in case run as part of a chain
    cd ../..
  fi
}

compilecoffeescripts() {
  find workspace/scripts -name "*.coffee" -exec coffee -cl '{}' \; -exec echo "Coffeescript compiled {}" \;
}

concatscripts() {
  target=$1
  rm -f $target
  files=`awk '/CONCAT_JS_LIST_START/ {flag=1;next} /CONCAT_JS_LIST_END/ {flag=0} flag {print}' workspace/utilities/master.xsl | grep -Po 'src="\K.*?(?=")'`
  for file in $files
  do
    cat .$file >> $target
    echo "Concatenated .$file to `basename $target`"
  done
}

closurecompilejs() {
  src=$1
  target=$2
  echo "Requesting compilation of `basename $src` from Google Closure Compiler..."
  curl -s \
    -d compilation_level=WHITESPACE_ONLY \
    -d output_format=text \
    -d output_info=compiled_code \
    --data-urlencode js_code@$src \
    -o $target \
    http://closure-compiler.appspot.com/compile
  if [ $? -eq 0 ]
  then
    echo "Google Closure compiled `basename $src` to $target"
  else
    echo "Google Closure failed to compile `basename $src`. Aborting."
    exit 1
  fi
}

compilestyles() {
  cd workspace/styles
  if [ -f main.less ]
  then
    echo "Compiling using Less CSS..."
    lessc main.less > main.css
    lessc --compress main.less > production.min.css
  elif [ -f main.sass ]
  then
    echo "Compiling using Sass (.sass format)..."
    sass main.sass main.css
    sass --style compressed main.sass production.min.css
  elif [ -f main.scss ]
  then
    echo "Compiling using Sass (.scss format)..."
    sass main.scss main.css
    sass --style compressed main.scss production.min.css
  elif [ -f main.styl ]
  then
    echo "Compiling using Stylus..."
    stylus < main.styl > main.css
    stylus -c < main.styl > production.min.css
  fi
  if [ $? -eq 0 ]
  then
    echo "Compiled styles into production.min.css"
    rm -f production-*.min.css
    echo "Removed old production-SHA1.min.css files"
    newsha=`shasum production.min.css | awk '{print substr($0,0,10)}'`
    mv production.min.css production-${newsha}.min.css
    echo "Moved production.min.css to SHA1 tagged 'production-$newsha.min.css'"
    sed -i '' "s|production-[a-f0-9]*\.min\.css|production-$newsha.min.css|" ../utilities/master.xsl
    echo "Updated master.xsl with new production-$newsha.min.css"
  else
    echo "Error: CSS Compilation failed! Aborting."
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
    else
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
    echo "指令繼續之前，您必須先..."
    echo "* 建立所需的 MySQL 資料庫 (請使用 utf-8 編碼)"
    echo "* 建立管理 MySQL 資料庫的管理員名稱與密碼"
    echo "* 設定網站伺服器（通常是 Apache）運行您的網站 `pwd`/$project"
  fi
}

cmd=$1
case $cmd in
        new) new $2;;
 extensions) extensions;;
    compile) compile $2;;
   setperms) setperms $2 $3;;
   fixperms) fixperms;;
          *) usage
esac
