# -*- coding: utf-8 -*-
require 'thor'
require 'autosftp/monitor'
require 'autosftp/file_access'
require 'autosftp/connection'

module Autosftp
  class CLI < Thor

    desc "start [remote name]", "Automatic monitoring start"
    def start(*word)
      if false == Autosftp::FileAccess.exist?
        puts "is not .autosftp \n $ autosftp init"
        exit
      end

      conf = Autosftp::FileAccess.read
      if !conf[word[0]]
        puts "is not setting \n $ autosftp set [remote name]"
        exit
      elsif
        setting = conf[word[0]]
        word.delete_at(0)
      end

      if 0 < word.size
        dir = word.map {|a| a.to_s + "**/*"}
      else
        dir = '**/*'
      end

      Autosftp::Monitor.start setting, dir
    end

    desc "set [remote name]", "add information to the '.autosftp'. Please put the name of any [remote name]"
    def set(word)
      ssh_hash = {}

      begin
        puts "[username@host:port]"
        ssh_str = STDIN.gets.chomp
        if false == Autosftp::Connection.check?(ssh_str)
          puts "is not [username@host:port]"
          exit
        end

        ssh_hash = Autosftp::Connection.explode ssh_str

        puts "password:"
        ssh_hash[:password] = STDIN.noecho(&:gets).chomp

        puts "remote path:"
        ssh_hash[:remote_path] = STDIN.gets.chomp

        puts "local path: --If you enter a blank, the current directory is set"
        ssh_hash[:local_path] = STDIN.gets.chomp
        if '' == ssh_hash[:local_path]
          ssh_hash[:local_path] = Dir.pwd
          puts ssh_hash[:local_path]
        end

        Autosftp::FileAccess.save word, ssh_hash

      rescue Interrupt
      end
    end

    desc "delete [remote name]", "remove the configuration."
    def delete(word)
      Autosftp::FileAccess.delete word
    end

    desc "list", "setting list"
    def list()
      Autosftp::FileAccess.read.each do |key, value|
        puts <<"EOS"

#{key}:
  host:        #{value[:host]}
  local_path:  #{value[:local_path]}
  remote_path: #{value[:remote_path]}

EOS
      end
    end

    desc "init", "Creating the initial file. file called '.autosftp' is created"
    def init
      init_file = Autosftp::FileAccess
      if true == init_file.exist?
        if yes? "File exists. Overwrite the file? [y/n]"
          init_file.create
          puts 'overwite!!! (' + init_file.path + ')'
        else
          puts 'cancel'
        end
      else
        init_file.create
        puts 'create!!! (' + init_file.path + ')'
      end
    end

  end
end
