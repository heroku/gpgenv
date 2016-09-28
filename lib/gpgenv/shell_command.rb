require 'gpgenv'
require 'shellwords'
require 'clamp'
require 'gpgenv/base_command'

class Gpgenv
  class ShellCommand  < Gpgenv::BaseCommand

    def execute
      gpgenv.read_files.each do |k, v|
        puts "export #{k}=#{Shellwords.escape(v)}"
      end
    end

  end
end
