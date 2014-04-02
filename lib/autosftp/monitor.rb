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

        update do |base, file|
          begin
            Autosftp::Connection.create setting, "#{base}/#{file}", "#{setting[:remote_path]}/#{file}"
            puts "U: #{Time.now} #{setting[:remote_path]}/#{file}"
          rescue
            puts "EU: #{Time.now} #{setting[:remote_path]}/#{file}"
          end
        end

        create do |base, file|
          begin
            Autosftp::Connection.create setting, "#{base}/#{file}", "#{setting[:remote_path]}/#{file}"
            puts "C: #{Time.now} #{setting[:remote_path]}/#{file}"
          rescue
            puts "EC: #{Time.now} #{setting[:remote_path]}/#{file}"
          end
        end

        delete do |base, file|
          begin
            Autosftp::Connection.delete setting, "#{setting[:remote_path]}/#{file}"
            puts "D: #{Time.now} #{setting[:remote_path]}/#{file}"
          rescue
            puts "ED: #{Time.now} #{setting[:remote_path]}/#{file}"
          end
        end

      end
    end

  end
end
