require_relative './base'
require_relative './config_file'

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
        cf = ::SwitchUser::ConfigFile.new(account, user)
        cf.must_exist
        cf.switch(false)
      rescue => e
        log e.message
        cf = ::SwitchUser::ConfigFile.new
        cf.switch(true)
      end
    end
  end

end
