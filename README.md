Note: 基本上這 repo 僅異動 Symphony Book 的部分。

## Symphony 攻略

Craig Zheng's [Symphony book project was cancelled](http://book.symphony-cms.com/).

期待中的 Symphony CMS 教學書籍，最後不知為何取消了。在2012年10月下旬，Symphony 團隊將未出版的草稿全文在 github 上釋出。但非常可惜，Craig 所製作的那個書籍網站並未包含在內。不管如何，會根據這些文本，製作自己的學習文件。

話說 Symphony Book Project 網站出現的時候，數位閱讀、特別是瀏覽器中的閱讀（Books in Browsers）還不太盛行（其實目前也不算主流），這個網站有非常好的目錄組織、文件呈現，以及修改自部落格評論系統而來的討論及注解功能，雛形十分完整，不輸給目前的 [Pressbooks](http://pressbooks.com)。

（以下僅為個人紀錄）

## Symphony CMS 是什麼？

Symphony 是一個以 PHP 開發，使用 XSLT 作為主要的模板開發語言，足以建置各種網站的一個「內容管理系統開發框架」（CMS Framework）。

它的核心概念很有趣，你可以自訂任意的內容結構（Section, Fields），建立條件取出資料、製成 XML（Datasource），並使用 XSLT 開發頁面模板、決定最終要呈現的資料、內容與格式（Page Template）。如果需要送進資料、產生互動，Symphony 提供了事件（Event），基本上就是常見的 HTML Form。常用的 XSLT 區塊模板還能做成可重複利用的 Utilities。

有許多擴充 Symphony 的外掛，稱之為 Extension，開發外掛就必須使用 PHP 了，據說未來（Symphony 3）有可能讓人們只使用 XSLT 來建制基本的外掛，但目前還只進展到 2.3 而已。

當然，Symphony 還有很多特點，例如很容易使用的網址列參數（URL Parameter）、主要的內容輸入是 Markdown，以及目前看過最聰明的圖片處理與自動快取機制 [Just In Time(JIT) Image Manipulation](http://symphonyextensions.com/extensions/jit_image_manipulation/)，整個網站的打包發佈（使用 Ensemble）也非常容易。

## MVC

程式開發者或許都熟悉 MVC 這個[三層架構模式](http://zh.wikipedia.org/wiki/MVC)，Symphony 把這個概念拉到內容管理與網站建置的更上層，或許也正是可被稱為「內容管理框架」的原因。

* Model：對應 Sections 與 Fields，用來規劃、建置與儲存資料，有點像是更加友善的資料庫管理。
* View：對應 Page templates 與 Utilities，這一層都使用 XSLT 撰寫。
* Control：對應 Pages、Data sources 與 Events。

## 要善用 Symphony CMS

1. 由於 Symphony 完全是從空白開始，因此事前的規劃非常重要，而且必須要到非常細緻才行，這其實是第一道門檻。
2. 非常熟悉 XSLT。雖然 XSLT 相較各種程式語言來說，語法少很多，不算難入門，但事情總有一體兩面：基礎指令愈簡單，就表示進階功能的撰寫愈困難；常常翻到前輩的範例程式才驚呼，原來可以這樣思考。Cookbook 或從範例中學習很重要。
3. 前端框架。目前是整合 [Twitter Bootstrap](http://twitter.github.com/bootstrap/)。
4. Javascript，基本上 Symphony CMS 以頁面為單位來組織，透過 URL 參數，基本上很像 REST。想要更複雜的互動操作，或是降低頁面重整、即時更新部分區塊，還是需要前端 JS 的搭配。