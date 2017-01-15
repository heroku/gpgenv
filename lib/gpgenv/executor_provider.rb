require 'gpgenv/profile'
class Gpgenv
  module ExecutorProvider
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
