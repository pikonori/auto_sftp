# -*- coding: utf-8 -*-
require 'net/ssh'
require 'net/sftp'

module Autosftp
  class Connection

    # username@host:port形式かどうかチェックする。
    def self.check? sftp
      if /.*\@.*|.*\@.*\:.*/ =~ sftp
        true
      else
        false
      end
    end

    # username@host:port形式を分解する。
    def self.explode sftp
      ssh_hash = {}
      if /.*\@.*/ =~ sftp
        user_host_ary = sftp.split("@")
        ssh_hash[:user] = user_host_ary[0]
        if /.*\:.*/ =~ user_host_ary[1]
          host_port_ary = user_host_ary[1].split(":")
          ssh_hash[:host] = host_port_ary[0]
          ssh_hash[:port] = host_port_ary[1].to_i
        else
          ssh_hash[:host] = user_host_ary[1]
          ssh_hash[:port] = 22
        end
      end
      ssh_hash
    end

    # ファイルの新規作成＋更新
    def self.create ssh_hash, local_file, remote_file, permission
      Net::SSH.start(ssh_hash[:host], ssh_hash[:user], {:password => ssh_hash[:password], :port => ssh_hash[:port]}) do |ssh|
        ssh_dir(ssh, File.dirname(remote_file), permission)
        if File.exist? local_file
          ssh.sftp.upload!(local_file, remote_file)
          ssh.exec! "chmod #{permission[:file]} #{remote_file}"
        end
      end
    end

    # ファイルの削除
    def self.delete ssh_hash, remote_file
      Net::SSH.start(ssh_hash[:host], ssh_hash[:user], {:password => ssh_hash[:password], :port => ssh_hash[:port]}) do |ssh|
        ssh.sftp.remove!(remote_file)
      end
    end

    # ディレクトリの作成
    def self.ssh_dir ssh, path, permission
      ssh.sftp.stat!(path)
    rescue
      parent = File::dirname(path);
      ssh_dir(ssh, parent)
      ssh.sftp.mkdir!(path, :permissions => permission[:dir])
    end

  end

end

