require 'gpgenv'
require 'shellwords'
require 'clamp'

module Gpgenv
  class ShellCommand  < Clamp::Command

    def execute
      Gpgenv.read_files.each do |k, v|
        puts "export #{k}=#{Shellwords.escape(v)}"
      end
    end

  end
end
