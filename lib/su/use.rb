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
        switchUser account, user
        puts
      rescue => e
        log e.message
      end
    end
  end

end
