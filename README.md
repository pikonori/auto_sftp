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

設定したsftpの情報を確認します。

    $ autosftp list

設定したsftpを削除します。

    $ autosftp delete [remote name]

## これからの予定

- 鍵認証出来るようにする。

## 連絡先

https://twitter.com/pikonori

