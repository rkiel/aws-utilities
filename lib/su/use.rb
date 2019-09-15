require_relative './base'
require_relative './safe'
require_relative './ssh_config_file'

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
        cf = ::SwitchUser::SshConfigFile.new(account, user)
        cf.export
        ::SwitchUser::Safe.switch(false, account, user)
      rescue => e
        log e.message
        ::SwitchUser::Safe.switch(true)
      end
    end
  end

end
