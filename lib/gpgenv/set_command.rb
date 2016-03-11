require 'clamp'
require 'gpgenv'

module Gpgenv
  class SetCommand < Clamp::Command

    parameter "ARGUMENTS ...", "arguments", :attribute_name => :args

    def execute
      FileUtils.mkdir_p(Gpgenv.dir)
      if args.size == 1
        Gpgenv.set(args[0], STDIN.read)
      elsif args.size == 2
        Gpgenv.set(args.first, args.last)
      else 
        fail("Usage: gpgset KEY [VALUE]")
      end
    end

  end
end
