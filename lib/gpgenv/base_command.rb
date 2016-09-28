require 'clamp'
class Gpgenv
  class BaseCommand < Clamp::Command

    option ['-d', '--dir'], "DIR", "Directory to read env files from", default: "#{Dir.pwd}/.gpgenv"

    def gpgenv
      @gpgenv ||= Gpgenv.new(dir: dir) 
    end

  end
end
