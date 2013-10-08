# -*- coding: utf-8 -*-

require 'fssm'
require 'net/ssh'
require 'net/sftp'
require 'io/console'
require 'yaml'


# ファイルモードと直接入力モードの２つが存在します。
# ファイルモードでの起動の場合はsftp.yamlの記載が必須になります。
# $ ruby sftp.rb -f servername
# servernameはyamlに記載されている上位のキーになります。
#
# 直接入力モードでの起動の場合はserver情報を入れます。
# 直接入力モードは対話型の処理です。
# $ ruby sftp.rb -i username@host:port
module NJC
  class SFTP
    def initialize
      @file_perm = 0644
      @dir_perm = 0755

      @local_path = ""
      @remote_path = ""

      @ip = ""
      @user = ""
      @port = 22
      @password = ""
    end

    # 直接入力モード
    def cli sftp
      if explode(sftp) == false
        puts "Argument ERROR"
        exit
      end
      puts "Password:"
      @password = STDIN.noecho(&:gets).chomp

      begin
        Net::SSH.start(@ip, @user, {:password => @password, :port => @port})
      rescue
        puts "Connection ERROR"
        exit
      end

      puts "LocalPath:"
      @local_path = STDIN.gets.chomp
      puts "RemotePath:"
      @remote_path = STDIN.gets.chomp

    end

    # yaml読み込みモード
    def file name
      yaml = YAML.load_file File.expand_path(File.dirname(__FILE__) + '/sftp.yaml')

      unless yaml[name]
        puts "ERROR: Server does not exist"
        exit
      end

      @local_path = yaml[name]["local_path"]
      @remote_path = yaml[name]["remote_path"]

      @ip = yaml[name]["ip"]
      @user = yaml[name]["user"]
      if yaml[name]["port"]
        @port = yaml[name]["port"]
      end
      @password = yaml[name]["password"]
    end

    # yamlの中身が見れる
    def file_all
      yaml = YAML.load_file File.expand_path(File.dirname(__FILE__) + '/sftp.yaml')
      yaml.each do |key, value|
        puts <<"EOS"

#{key}:
    ip:          #{value["ip"]}
    local_path:  #{value["local_path"]}
    remote_path: #{value["remote_path"]}

EOS
      end
    end

    # ヘルプが見れる。
    def help
      puts <<"EOS"


-f:
     sftp.yamlに書かれているファイルを呼び出してSSHで接続します。
     example: $ ruby sftp.rb servername
              servernameはyamlに記載されている上位のキーになります。

-i:
     対話型で接続します。
     example: $ ruby sftp.rb -i username@host:port

-r:
     リモート先を確認出来ます。

-h:
     helpが表示されます。



EOS
    end

    # 除外するファイル名
    def ignore file_name
      if /^\#.*\#$/ =~ file_name
        false
      else
        true
      end
    end

    # username@ip:port形式の引数を分解する。
    def explode sftp
      if /.*\@.*/ =~ sftp
        user_ip_ary = sftp.split("@")
        @user = user_ip_ary[0]
        if /.*\:.*/ =~ user_ip_ary[1]
          ip_port_ary = user_ip_ary[1].split(":")
          @ip = ip_port_ary[0]
          @port = ip_port_ary[1]
        else
          @ip = user_ip_ary[1]
        end
        true
      else
        false
      end
    end

    # 接続先の指定、イテレータがない場合は無視
    def create local_file, remote_file
      Net::SSH.start(@ip, @user, {:password => @password, :port => @port}) do |ssh|
        ssh.sftp.connect do |sftp|

          remote_dir = File.dirname(remote_file)
          begin
            sftp.stat!(remote_dir)
          rescue Net::SFTP::StatusException => e
            raise unless e.code == 2
            ssh.open_channel do |channel|
              channel.exec "mkdir -p #{remote_dir}"
              channel.exec "chmod #{@dir_perm} #{remote_dir}"
              channel.exec "exit"
            end
          end

          begin
            sftp.upload!(local_file, remote_file)
          rescue Net::SFTP::StatusException => e
            raise unless e.code == 2
            sftp.upload!(local_file, remote_file)
            sftp.setstat(remote_file, :permissions => @file_perm)
          end

        end
      end

    end

    # ファイルの削除
    def delete remote_file
      Net::SSH.start(@ip, @user, {:password => @password, :port => @port}) do |ssh|
        ssh.sftp.connect do |sftp|
          sftp.remove!(remote_file)
        end
      end
    end

    attr_reader :local_path
    attr_reader :remote_path
    attr_reader :ip

  end
end

njc_sftp = NJC::SFTP.new();

if ARGV[0] == "-f"
  njc_sftp.file(ARGV[1])
  server_name = ARGV[1]
elsif ARGV[0] == "-i"
  njc_sftp.cli(ARGV[1])
  server_name = "none"
elsif ARGV[0] == "-r"
  njc_sftp.file_all
  exit
elsif ARGV[0] == "-h"
  njc_sftp.help
  exit
else
  puts "Option Error"
  exit
end


local_path = njc_sftp.local_path
remote_path = njc_sftp.remote_path

FSSM.monitor(local_path, '**/*') do
  puts "C: create  U: update  D: delete E: error"
  puts ""
  puts "Name      #{server_name}"
  puts "Host      #{njc_sftp.ip}"
  puts "Accepted  #{Time.now}"
  puts ""

  update do|base, file|
    if njc_sftp.ignore(file) == true
      begin
        njc_sftp.create "#{base}/#{file}", "#{remote_path}/#{file}"
        puts "U: #{Time.now} #{remote_path}/#{file}"
      rescue
        puts "EU: #{Time.now} #{remote_path}/#{file}"
      end
    end
  end

  create do|base, file|
    if njc_sftp.ignore(file) == true
      begin
        njc_sftp.create "#{base}/#{file}", "#{remote_path}/#{file}"
        puts "C: #{Time.now} #{remote_path}/#{file}"
      rescue
        puts "EC: #{Time.now} #{remote_path}/#{file}"
      end
    end
  end

  delete do|base, file|
    if njc_sftp.ignore(file) == true
      begin
        njc_sftp.delete "#{remote_path}/#{file}"
        puts "D: #{Time.now} #{remote_path}/#{file}"
      rescue
        puts "ED: #{Time.now} #{remote_path}/#{file}"
      end
    end
  end
end
