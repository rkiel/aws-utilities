require_relative './base'

module SwitchUser

  class Add < SwitchUser::Base

    def valid?
      argv.size == 6
    end

    def help
      "#{script_name} add account user pathToCsvFile region format"
    end

    def execute
      action = argv.shift
      account = argv.shift
      user = argv.shift
      path = argv.shift
      region = argv.shift
      format = argv.shift

      begin
        create account, user, path, region, format
      rescue => e
        puts e.message
      end
    end
  end

end
