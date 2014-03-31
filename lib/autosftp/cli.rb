# -*- coding: utf-8 -*-
require 'thor'
require 'autosftp'

module Autosftp
  class CLI < Thor
    desc "start [remote name]", "Automatic monitoring start"
    def start(word)
      say(word, :red)
    end

    desc "set [remote name]", "add information to the '.autosftp'. Please put the name of any [remote name]"
    def set(word)
      say(word, :red)
    end

    desc "delete [remote name]", "remove the configuration."
    def delete(word)
      say(word, :red)
    end

    desc "list", "setting list"
    def list()
      say(word, :red)
    end

    desc "init", "Creating the initial file. file called '.autosftp' is created"
    def init()
      say(word, :red)
    end

  end
end
