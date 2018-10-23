require_relative './base'

module SwitchUser

  class Initialize < SwitchUser::Base

    def valid?
      argv.size == 3
    end

    def help
      "#{script_name} initialize account user"
    end

    def execute
      action = argv.shift
      account = argv.shift
      user = argv.shift

      begin
        init account, user
      rescue => e
        puts e.message
      end
    end
  end

end
