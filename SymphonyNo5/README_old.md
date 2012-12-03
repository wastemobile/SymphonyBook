## Symphony CMS

Symphony CMS真的不算是個簡單的玩意，相較大多數的部落格系統、內容管理系統來說，它的安裝程序沒那麼容易、更新更是麻煩，使用的又是一般人根本不覺得算是個「開發語言」的XSLT，甚至於最近還有一種JSON超越XML的說法，讓它顯得更顯小眾。

使用Symphony CMS（以下皆以Sym代稱） 可能必須俱備下列要求：

1. 懂得使用 Git。Sym主程序擺在github，外掛（extensions）也採用git submodule管理，雖然人們還是可以直接下載壓縮檔、FTP上傳主機並進行安裝，但後續維護就很麻煩。
2. 熟練XSLT。Sym的主要開發語言是XSLT。
3. 懂得PHP。雖然單純的架站、使用第三方外掛，可以完全不碰PHP，但遇到始終沒人開發的功能，就麻煩了。對一般開發者來說，開發一個片段的PHP功能專供Sym使用、還得符合它的API與開發原則，會讓大多數習慣直接用PHP刻程式的人卻步。

其實Sym還有另一個麻煩，就是開發環境與正式環境不容易切割。Sym將主機建置的資訊擺放在manifest目錄下，通常會用.gitignore排除同步更新，目前常見的方式是建立不同的目錄，例如 manifest.dev 與 manifest.prod，再使用 manifest link 到其中之一。

設定檔有方法解決，但資料庫同步更麻煩。因為Sym's Extensions常常會異動資料庫，兩者的同步很麻煩。

# Symphony No.5 Command Line Tool 終端機命令列工具

* Version 0.2.0
* Date: 24th November 2012

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

### 編譯所有前端資源檔，製成單一最小化的檔案，並更新 `master.xsl`

    symphonyno5 compile

### 只編譯 Coffescript & Javascript

    symphonyno5 compile scripts

### 只編譯 Less, Sass 或 Stylus 樣式表

    symphonyno5 compile styles

### 設定目錄與檔案權限

    symphonyno5 setperms 0775 0664

### 根據 `manifest/config.php` 修復目錄與檔案權限

    symphonyno5 fixperms

## Changelog

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