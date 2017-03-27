require 'clamp'
require 'fileutils'
class Gpgenv
  class BaseCommand < Clamp::Command

    option ['-d', '--dir'], "DIR", "Directory to read env files from", default: "./.gpgenv"

    def gpgenv
      # Create a new empty directory if we're using the default.
      if dir == './.gpgenv'
        FileUtils.mkdir_p(dir)
      end
      @gpgenv ||= Gpgenv.new(dir: dir)
    end

  end
end
