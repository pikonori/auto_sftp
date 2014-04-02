# -*- coding: utf-8 -*-
require File.expand_path('spec_helper', File.dirname(__FILE__))
require 'autosftp/connection'

describe Autosftp::Connection do
  before :each do
    @connection = Autosftp::Connection
  end

  it '正規表現チェックOK' do
    expect(@connection.check?('aaa@0000.0000.0000.0000:22')).to eq true
  end

  it '正規表現チェックOK' do
    expect(@connection.check?('aaa@0000.0000.0000.0000')).to eq true
  end

  it '正規表現チェックNG' do
    expect(@connection.check?('aaa')).to eq false
  end

  it '正規表現チェックNG' do
    expect(@connection.check?('aaa:22')).to eq false
  end

  it 'username@host:portを分解OK' do
    expect(@connection.explode('aaa@0000.0000.0000.0000:2200')).to include(:user => "aaa", :host => "0000.0000.0000.0000", :port => 2200)
  end

  it 'username@hostを分解OK' do
    expect(@connection.explode('aaa@0000.0000.0000.0000')).to include(:user => "aaa", :host => "0000.0000.0000.0000", :port => 22)
  end

  it 'usernameを分解NG' do
    expect(@connection.explode('aaa')).to include()
  end

end
