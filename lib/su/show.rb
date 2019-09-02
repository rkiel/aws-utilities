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
        puts
        json_hash = get_user()
        puts JSON.pretty_generate json_hash
        puts
      rescue => e
        log e.message
      end
    end
  end

end
