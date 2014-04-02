# -*- coding: utf-8 -*-
require 'yaml'

module Autosftp
  class FileAccess
    class << self

      INIT_FILE = '.autosftp'
      def create
        File.open(path, "w").close()
      end

      def path
        File.join(Dir.pwd, INIT_FILE)
      end

      def exist?
        File.exist? path
      end

      def save word, hash
        save_file = YAML.load_file path
        if false == save_file
          save_file = {}
        end
        save_file[word] = hash

        f = open(path, "w")
        f.write(YAML.dump(save_file))
        f.close
      end

      def read
        YAML.load_file path
      end

      def delete word
        read_file = YAML.load_file path
        read_file.delete(word)

        f = open(path, "w")
        f.write(YAML.dump(read_file))
        f.close
      end

    end
  end
end
