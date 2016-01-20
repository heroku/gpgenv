require 'clamp'
require 'gpgenv'

module Gpgenv
  class ExecCommand < Clamp::Command

    parameter "ARGUMENTS ...", "arguments", :attribute_name => :args

    def execute
      cmd = args.last
      directories = args[0..-2]
      hash = Gpgenv.read_files(directories)
      hash.each{ |k,v| ENV[k]=v }
      exec cmd
    end

  end
end
