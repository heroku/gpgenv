require 'clamp'
require 'gpgenv/base_command'
require 'gpgenv'

class Gpgenv
  class ExecCommand < Gpgenv::BaseCommand

    parameter "ARGUMENTS ...", "arguments", :attribute_name => :args

    def execute
      gpgenv.exec_command args[0..-1].join(' ')
    end

  end
end
