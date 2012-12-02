# Symphony No.5

## Symphony CMS

Symphony CMS真的不算是個簡單的玩意，相較大多數的部落格系統、內容管理系統來說，它的安裝程序沒那麼容易、更新更是麻煩，使用的又是一般人根本不覺得算是個「開發語言」的XSLT，甚至於最近還有一種JSON超越XML的說法，讓它顯得更顯小眾。

使用Symphony CMS（以下皆以Sym代稱） 可能必須俱備下列要求：

1. 懂得使用 Git。Sym主程序擺在github，外掛（extensions）也採用git submodule管理，雖然人們還是可以直接下載壓縮檔、FTP上傳主機並進行安裝，但後續維護就很麻煩。
2. 熟練XSLT。Sym的主要開發語言是XSLT。
3. 懂得PHP。雖然單純的架站、使用第三方外掛，可以完全不碰PHP，但遇到始終沒人開發的功能，就麻煩了。對一般開發者來說，開發一個片段的PHP功能專供Sym使用、還得符合它的API與開發原則，會讓大多數習慣直接用PHP刻程式的人卻步。

其實Sym還有另一個麻煩，就是開發環境與正式環境不容易切割。Sym將主機建置的資訊擺放在manifest目錄下，通常會用.gitignore排除同步更新，目前常見的方式是建立不同的目錄，例如 manifest.dev 與 manifest.prod，再使用 manifest link 到其中之一。

設定檔有方法解決，但資料庫同步更麻煩。因為Sym's Extensions常常會異動資料庫，兩者的同步很麻煩。
