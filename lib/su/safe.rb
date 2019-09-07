require_relative './base'
require_relative './config_file'

module SwitchUser

  class Safe < SwitchUser::Base

    def valid?
      argv.size == 1
    end

    def help
      "#{script_name} safe"
    end

    def execute

      begin
        cf = ::SwitchUser::ConfigFile.new
        cf.switch(true)
      rescue => e
        log e.message
      end
    end
  end

end
