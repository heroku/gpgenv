require 'clamp'

module Gpgenv
  class ExportCommand < Clamp::Command
    parameter 'DIRS ...', 'dirs', :attribute_name => :directories

    option '--file', 'FILE', 'env file to read from', :default => '.env'

    def full_dir
      if ENV['GPGENV_HOME']
        "#{ENV['GPGENV_HOME']}/#{dir}"
      else
        dir
      end
    end

    def execute
      hash = Gpgenv.read_files(directories)
      str = ''
      hash.each do |k,v|
        str << "#{k}=#{v}\n"
      end
      File.write(file, str)
    end

  end
end
