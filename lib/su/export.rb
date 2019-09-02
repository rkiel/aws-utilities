require_relative './base'

module SwitchUser

  class Export < SwitchUser::Base

    def valid?
      argv.size == 4
    end

    def help
      "#{script_name} export account user profile"
    end

    def execute
      action = argv.shift
      account = argv.shift
      user = argv.shift
      profile = argv.shift

      begin
        file_name = json_name(account, user)
        file_not_must_exist file_name

        json_hash = get_user(profile)
        log "Adding #{file_name}"
        write_json file_name, json_hash
      rescue => e
        log e.message
      end
    end
  end

end
