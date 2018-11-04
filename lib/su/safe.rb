require_relative './base'

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
        puts
        safe_mode
        puts
      rescue => e
        log e.message
      end
    end
  end

end
