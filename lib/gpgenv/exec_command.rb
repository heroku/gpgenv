require 'clamp'
require 'gpgenv'

module Gpgenv
  class ExecCommand < Clamp::Command

    parameter "ARGUMENTS ...", "arguments", :attribute_name => :args

    def execute
      Gpgenv.exec_command args[0..-1].join(' ')
    end

  end
end
