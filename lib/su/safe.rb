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
        safe
      rescue => e
        puts e.message
      end
    end
  end

end
