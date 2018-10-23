require_relative './base'

module SwitchUser

  class Remove < SwitchUser::Base


    def valid?
      argv.size == 3
    end

    def help
      "#{script_name} remove account user"
    end

    def execute
      action = argv.shift
      account = argv.shift
      user = argv.shift

      begin
        remove account, user
      rescue => e
        puts e.message
      end
    end
  end

end
