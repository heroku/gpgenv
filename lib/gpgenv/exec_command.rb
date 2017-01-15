require 'clamp'
require 'gpgenv/base_command'
require 'gpgenv/profile'
require 'gpgenv'

class Gpgenv
  class ExecCommand < Gpgenv::BaseCommand

    option ['-p', '--profile'], "PROFILE", "Profile to use, from ~/.gpgenvrc", attribute_name: :profile
    parameter "ARGUMENTS ...", "arguments", :attribute_name => :args

    def execute
      executor.exec_command args[0..-1].join(' ')
    end

    def executor
      # If GPGENV_PRPOFILE is set or a profile is passed on the CLI, use the given profile
      # Otherwise use a standard Gpgenv object to execute.
      if prof
        Profile.new("#{ENV['HOME']}/.gpgenvrc", prof)
      else
        gpgenv
      end  
    end

    def prof
      profile || ENV['GPGENV_PROFILE']
    end

  end
end
