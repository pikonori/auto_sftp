# Autosftp

ローカルファイルを監視し、自動でファイルをアップします。

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

