require 'clamp'
require 'gpgenv'
require 'gpgenv/base_command'

class Gpgenv
  class SetCommand < Gpgenv::BaseCommand 

    parameter "ARGUMENTS ...", "arguments", :attribute_name => :args

    def execute
      FileUtils.mkdir_p(Gpgenv.dir)
      if args.size == 1
        gpgenv.set(args[0], STDIN.read)
      elsif args.size == 2
        gpgenv.set(args.first, args.last)
      else 
        fail("Usage: gpgset KEY [VALUE]")
      end
    end

  end
end
