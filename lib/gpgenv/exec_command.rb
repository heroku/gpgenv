require 'gpgenv/env'

module Gpgenv
  class ExecCommand

    attr_reader :args

    def initialize(args)
      @args = args
    end

    def run
      fail("Usage: gpgenv dir1 dir2 dir3 ... command") unless args.size >= 2
      directories = args[0..-2]
      cmd = args.last
      hash = Env.read_files(directories)
      hash.each{ |k,v| ENV[k]=v }
      exec cmd
    end

  end
end
