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

### 設定ファイルを準備します。プロジェクトの直下で作成したほうが良いです。

    $ autosftp init

### 設定ファイルに接続先の情報を追加します。[remote name]は自由な名称をつけて下さい。

    $ autosftp set [remote name]

### 自動監視をスタートします。

    $ autosftp start [remote name]

