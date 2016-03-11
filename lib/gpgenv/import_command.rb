require 'gpgenv'
require 'shellwords'
require 'clamp'

module Gpgenv
  class ImportCommand  < Clamp::Command

    option ['-f', '--force'], :flag, "Force overwrite of existing .gpg directory, totally erases it."

    def execute
      if File.exist?(Gpgenv.dir) && !force?
        fail("#{Gpgenv.dir} already exists. Use --force to overwrite it.")
      end

      FileUtils.mkdir_p(Gpgenv.dir)
      File.open('.env', 'r').each_line do |line|
        i = line.index('=')
        key=line[0..i-1]
        value=line[i+1..-1]
        Gpgenv.set(key, value)
      end
    end

  end
end
