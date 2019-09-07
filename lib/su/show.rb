require_relative './base'
require_relative './config_file'

module SwitchUser

  class Show < SwitchUser::Base

    def valid?
      argv.size == 1
    end

    def help
      "#{script_name} show"
    end

    def execute

      begin
        cf = ::SwitchUser::ConfigFile.new
        cf.show
      rescue => e
        log e.message
      end
    end
  end

end
