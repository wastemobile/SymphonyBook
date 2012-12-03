# Symphony No.5 Command Line Tool 終端機命令列工具

* Version 0.3.0
* Date: 3rd December 2012

### 額外的使用方法

Symphonyno5.sh 指令預設是先抓取 Symphony No.5 的官方倉儲（第74行），再根據其中的 extensions.csv 安裝外掛，因此建立完一個新專案後，需要將另外準備的外掛清單拷貝進來，再執行一次 `symphonyno5.sh extensions`，才會根據自己的設定一次安裝完所有外掛。

由於使用此程序安裝的開發專案，預設是沒有遠端倉儲的（應該是為了讓開發者能夠對應到自己的遠端），因此可以考慮一種方式：開另一個獨立的 github repo，只維護一個 extensions.csv 外掛清單，以 submodule 的方式掛進開發專案。

## 概觀

Symphony No.5 終端機命令列工具是一個用來輕鬆管理 [Symphony No.5](http://github.com/firegoby/symphonyno5.git) 的 bash script。

## 功能

* 建立與設置新的 Symphony CMS 開發專案。
* 根據 `extensions.csv` 檔案列表，更新與安裝 Symphony 的 git submodules 外掛。
* 編譯且串聯 Coffeescript 與 Javascript 檔案，產生單一最小化的正式檔案。
* 將 LESS、Sass 或 Stylus 撰寫的格式，編譯成單一經壓縮過的 CSS 樣式表。
* 設定正式環境的目錄與檔案權限。
* 根據 `manifest/config.php` 中的設定，修復目錄與檔案權限。

## 安裝

1. 拷貝 `symphonyno5` 到任意已存在於系統 `$PATH` 中的可執行目錄。
2. 執行 `chmod +x symphonyno5` 讓程序俱備可執行的權限。

	Mac 的環境路徑設定都在 /etc/paths 檔案中（可能需要 sudo 權限），使用 echo $PATH 指令可以觀看目前設定的所有路徑。我會在個人目錄下建立一個 bin 或 scripts 目錄，將這目錄加入路徑設定，未來還有各種非系統預設的程序要執行，就通通集中擺放。

## 如何使用

***Note**: 除了新增 `new` 指令之外，其它指令都要在專案的根目錄下運行。*

### 新建開發專案

    symphonyno5 new projectname

### 根據 `extensions.csv` 列表，更新/安裝 Symphony Extensions 

    symphonyno5 extensions

### 設定目錄與檔案權限

    symphonyno5 setperms 0775 0664

### 根據 `manifest/config.php` 修復目錄與檔案權限

    symphonyno5 fixperms

## FAQ

1. **為什麼所有 CSS 與 Javascript 編譯、最小化的功能都不見了？**

  一個專用於這些功能的外掛 [Asset Compiler](http://github.com/firegoby/asset_compiler) 已經誕生了！不再使用命令列，使用 master.xsl 中的標籤就能控制，試試看！（ps. 如果還是想用CLI，就用 git 切回 `0.2.0` 版吧。）

## Changelog

* 0.3.0 - 3 Dec 12
  * Removed `compile` commands
* 0.2.0 - 24 Nov 12
  * Remove Ant build script support
  * Compile javascript via Curl API call to Google Closure
  * Retask `fixperms` command
  * Add `setperms` command
  * Add plain `compile` command to compile all assets, CSS & JS
  * Misc refactoring/cleanup of code
* 0.1.1 - 22 Nov 12 
  * Drop the `.sh` extension from the script
  * Rename `submodules` command to `extensions`
* 0.1.0 - 21 Nov 12 - Initial release