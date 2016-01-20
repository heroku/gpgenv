require 'clamp'

module Gpgenv
  class ImportCommand < Clamp::Command
    option '--dir', 'DIRECTORY', 'directory, relative to $GPGENV_HOME, to store files in', :attribute_name => 'dir', :required => true
    option '--file', 'FILE', 'env file to read from', :default => '.env'

    def full_dir
      if ENV['GPGENV_HOME']
        index = ENV['GPGENV_HOME'].index('.password-store')
        prefix = ENV['GPGENV_HOME'][index+16..-1]
        "#{prefix}/#{dir}"
      else
        dir
      end
    end

    def execute
      IO.foreach(file) do |line|
        line = line.strip
        i = line.index('=')
        key=line[0..i-1]
        value=line[i+1..-1]
        value = value[1..-2] if value[0] == '"' && value[-1] == '"'
        cmd="echo \"#{Shellwords.shellescape(value)}\" | pass insert -f -m #{full_dir}/#{key}"
        puts cmd
        system "echo \"#{Shellwords.shellescape(key)}\" | pass insert -f -m #{full_dir}/#{key}"
      end
    end
  end
end

