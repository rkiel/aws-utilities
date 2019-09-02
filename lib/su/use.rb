require_relative './base'

module SwitchUser

  class Use < SwitchUser::Base

    def valid?
      argv.size == 3
    end

    def help
      "#{script_name} use account user"
    end

    def execute
      action = argv.shift
      account = argv.shift
      user = argv.shift

      begin
        puts
        switch_user(account, user)
        puts
      rescue => e
        log e.message
        puts
        safe_mode
        puts
      end
    end
  end

end
