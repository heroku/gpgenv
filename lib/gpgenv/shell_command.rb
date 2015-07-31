require 'gpgenv/env'
require 'shellwords'

module Gpgenv
  class ShellCommand 

    attr_reader :args

    def initialize(args)
      @args = args
    end

    def run
      fail("Usage: gpgshell dir1 dir2 ...") unless args.size >= 1
      hash = Env.read_files(args)
      hash.each do |k, v|
        puts "export #{k}=#{Shellwords.escape(v)}"
      end
    end

  end
end
