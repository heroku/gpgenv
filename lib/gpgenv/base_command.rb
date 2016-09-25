require 'clamp'
class Gpgenv
  class BaseCommand < Clamp::Command

    option ['-d', '--dir'], "DIR", "Directory to read env files from", default: Gpgenv.default_dir

    def gpgenv
      @gpgenv ||= Gpgenv.new(dir: dir) 
    end

  end
end