require_relative './base'
require_relative './safe'

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
        ::SwitchUser::Safe.switch(false, account, user)
      rescue => e
        log e.message
        ::SwitchUser::Safe.switch(true)
      end
    end
  end

end
