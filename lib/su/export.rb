require_relative './base'
require_relative './config_file'

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
        cf = ::SwitchUser::ConfigFile.new(account, user)
        cf.must_not_exist
        cf.export(profile)
        cf.save
      rescue => e
        log e.message
      end
    end
  end

end
