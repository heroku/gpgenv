require 'fileutils'
require 'gpgenv'
require 'gpgenv/base_command'
require 'shellwords'
require 'clamp'

class Gpgenv
  class ImportCommand  < Gpgenv::BaseCommand

    option ['-f', '--force'], :flag, "Force overwrite of existing .gpg directory, totally erases it."

    def execute
      if File.exist?(gpgenv.dir) && !force?
        fail("#{gpgenv.dir} already exists. Use --force to overwrite it.")
      end

      ::FileUtils.mkdir_p(gpgenv.dir)
      File.open('.env', 'r').each_line do |line|
        i = line.index('=')
        key=line[0..i-1]
        value=line[i+1..-1]
        gpgenv.set(key, value)
      end
    end

  end
end
