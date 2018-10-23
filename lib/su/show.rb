require_relative './base'

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
        show
      rescue => e
        puts e.message
      end
    end
  end

end
