# -*- coding: utf-8 -*-
require 'fssm'
require 'autosftp/connection'

module Autosftp
  class Monitor
    def self.start setting
      FSSM.monitor(setting[:local_path], '**/*') do
        puts "C: create  U: update  D: delete E: error"
        puts ""
        puts "Host      #{setting[:host]}"
        puts "Accepted  #{Time.now}"
        puts ""

        update do|base, file|
          puts "#{base}/#{file}  #{setting[:remote_path]}/#{file}"
          Autosftp::Connection.create setting, "#{base}/#{file}", "#{setting[:remote_path]}/#{file}"
        end

        create do|base, file|
          puts "#{base}/#{file}  #{setting[:remote_path]}/#{file}"
          Autosftp::Connection.create setting, "#{base}/#{file}", "#{setting[:remote_path]}/#{file}"
        end

        delete do|base, file|
          puts '削除'
        end

      end
    end

  end
end
