# Autosftp

ローカルファイルを監視し、自動でファイルをアップします。  
mac windows linuxで一応動作します。
windowsはruby 2.0系だと動作しない可能性がありますので気をつけて下さい。

## Installation

Add this line to your application's Gemfile:

    gem 'autosftp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install autosftp

## Usage

設定ファイルを準備します。プロジェクトの直下で作成したほうが良いです。  
yaml形式で.autosftpというファイルが作成されます。

    $ autosftp init

設定ファイルに接続先の情報を追加します。[remote name]は自由な名称をつけて下さい。  
直接.autosftpファイルを修正しても問題ありません。

    $ autosftp set [remote name]

自動監視をスタートします。

    $ autosftp start [remote name]

後ろにディレクトリを渡すことで、監視するディレクトリ先を選択することが出来ます。
setしたローカルディレクトリ移行のパスを指定して下さい。

    $ autosftp start [remote name] /app/
    # いくつでも渡すことが出来ます。
    $ autosftp start [remote name] /app/ /vender/

設定したsftpの情報を確認します。

    $ autosftp list

設定したsftpを削除します。

    $ autosftp delete [remote name]

## 設定のサンプル

プロジェクトのディレクトリに移動します。
（プロジェクトが/User/username/projectと仮定する。）

    $ cd /User/username/project

autosftpの設定ファイルを作成します。

    $ autosftp init

SFTPの設定を行います。
ここで重要なのが、ローカルのパスとリモートのパスを合わせる必要があります。
[remote name]は自由な名称をつけて下さい。

    $ autosftp set [remote name]

一度設定ファイル(.autosftp)を確認したほうが良いです。
中身が以下のようになっていたら設定完了です。
`remote_path` と `local_path` のパスは合わせて下さい。

    ---
    : [remote name]
      :user: username
      :host: test.com
      :port: 22
      :password: password
      :remote_path: /var/www/html/
      :local_path: /User/username/project/

監視をスタートします。

    $ autosftp start [remote name]

## これからの予定

- 鍵認証出来るようにする。

## 連絡先

https://twitter.com/pikonori

