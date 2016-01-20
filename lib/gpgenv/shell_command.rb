require 'gpgenv'
require 'shellwords'
require 'clamp'

module Gpgenv
  class ShellCommand  < Clamp::Command

    parameter "DIRECTORIES ...", "directories", :attribute_name => :directories

    def execute
      fail("You must specify at least one directory") unless directories.size >= 1
      hash = Gpgenv.read_files(directories)
      hash.each do |k, v|
        puts "export #{k}=#{Shellwords.escape(v)}"
      end
    end

  end
end
