require 'clamp'
require 'gpgenv'
require 'gpgenv/base_command'
require 'gpgenv/executor_provider'
require 'gpgenv/profile'

class Gpgenv
  class ExecCommand < Gpgenv::BaseCommand
    include ExecutorProvider

    option ['-p', '--profile'], "PROFILE", "Profile to use, from ~/.gpgenvrc", attribute_name: :profile
    parameter "ARGUMENTS ...", "arguments", :attribute_name => :args

    def execute
      executor.exec_command args[0..-1].join(' ')
    end

  end
end
