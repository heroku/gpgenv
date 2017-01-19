require 'clamp'
require 'gpgenv'
require 'gpgenv/base_command'
require 'gpgenv/executor_provider'
require 'shellwords'

class Gpgenv

  class ShellCommand  < Gpgenv::BaseCommand

    include ExecutorProvider

    option ['-p', '--profile'], "PROFILE", "Profile to use, from ~/.gpgenvrc", attribute_name: :profile

    def execute
      executor.read_files.each do |k, v|
        puts "export #{k}=$'#{v.gsub("'", "\\\\'").gsub("\n", "\\n")}'"
      end
    end

  end

end
