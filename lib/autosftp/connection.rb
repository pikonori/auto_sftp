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
          ssh_hash[:port] = host_port_ary[1]
        else
          ssh_hash[:host] = user_host_ary[1]
          ssh_hash[:port] = 22
        end
      end
      ssh_hash
    end

    # ファイルの新規作成＋更新
    def self.create ssh_hash, local_file, remote_file
      Net::SSH.start(ssh_hash[:host], ssh_hash[:user], {:password => ssh_hash[:password], :port => ssh_hash[:port]}) do |ssh|
        ssh.sftp.connect do |sftp|

          ssh_dir(sftp, File.dirname(remote_file))
          begin
            if File.exist? local_file
              sftp.upload!(local_file, remote_file)
            end
          rescue Net::SFTP::StatusException => e
            raise unless e.code == 2
            if File.exist? local_file
              sftp.upload!(local_file, remote_file)
              sftp.setstat(remote_file, :permissions => 0644)
            end
          end

        end
      end
    end

    # ファイルの削除
    def self.delete ssh_hash, remote_file
      Net::SSH.start(ssh_hash[:host], ssh_hash[:user], {:password => ssh_hash[:password], :port => ssh_hash[:port]}) do |ssh|
        ssh.sftp.connect do |sftp|
          sftp.remove!(remote_file)
        end
      end
    end

    # ディレクトリの作成
    def self.ssh_dir sftp, path
      sftp.stat!(path)
    rescue Net::SFTP::StatusException => e
      parent = File::dirname(path);
      ssh_dir(sftp, parent)
      sftp.mkdir!(path, :permissions => 0755)
    end

  end

end

