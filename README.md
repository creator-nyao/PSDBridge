# 使い方について
実はスクリプト群の紛失と導入方法の忘却を防ぐ為にgitに上げているだけなので、説明はしません。ごめんなさい。

# PSDBridge
AviUtl の PSDToolKitのPSD表示オブジェクトを準備オブジェクト（PDSBridge準備）と表示オブジェクト（PDSBridge表示）に分ける為のスクリプト群です。  
期待できるメリットは主に以下の二つです。

* PSDパス指定を単一のオブジェクトのみでできるようにする。  
* プロジェクトファイルのフォルダー内のPSDファイルであれば、疑似的に相対パスに似た動作をする。  
　※注意：パス指定で相対パスを使えるようになるわけではありません。
 
 なお、PSDBridgeはrikky_module.dllの導入が必要です。  
 「インストール」の項で説明している通りに導入してください。

# 注意事項
PSDBridge は無保証で提供されます。  
PSDBridge を使用したこと及び使用しなかったことによるいかなる損害について、開発者は何も保証しません。

これに同意できない場合、あなたは PSDBridge を使用することができません。

# お願い
PSDBridge はMITライセンスによりライセンスされています。  
しかし、PSDBridge を使用したことにより作成されたコンテンツ、または関連コンテンツに以下のようなクレジット表記をしていただくと開発者は喜びます。

・使用ツール  
PSDBridge（開発者：創作するにゃお）  
https://github.com/creator-nyao/PSDBridge/

上記のクレジット表記の書式、及びその掲載は強制ではありません。  
適宜書式を変えても構いませんし、負担になるのであれば掲載自体をしなくても問題ありません。

# ダウンロード
ここまで書いておきながら、リリースはしてないんですよね。  
すべてluaスクリプトとAviUtlのエイリアスで構成されているので、コードのダウンロードからお願いします。

# インストール
PSDBridge は以下の手順でインストールできます。

1. aviutl.exeを直下におくフォルダー（以下、【aviutlフォルダー】と呼ぶ）のバックアップを取る。  
2. 以下を参考にrikky_module.dllを導入する。  
https://hazumurhythm.com/wev/amazon/?script=rikkymodulea2Z&keyword=rikky&sort=viewh&filter=editor&page=1  
3. rikky_module.dllを 【aviutlフォルダー】/plugins/GCMZDrops/にコピー＆ペーストする。  
4. PSDBridge のコードのダウンロードを行う。  
5. aviutl.exeフォルダーの直下において、ダウンロードしたコード群のフォルダ（pluginsフォルダ）をコピー＆ペーストする。  
この際、【aviutlフォルダー】/plugins/GCMZDrops/psdtoolkit_psd.lua を上書きするか問われると思うので、それを実行する。  
6. インストール完了。

