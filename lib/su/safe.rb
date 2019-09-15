require_relative './base'
require_relative './config_file'
require_relative './ssh_config_file'
require_relative './pki_public_file'
require_relative './pki_private_file'

module SwitchUser

  class Safe < SwitchUser::Base

    def valid?
      argv.size == 1
    end

    def help
      "#{script_name} safe"
    end

    def execute
      begin
        ::SwitchUser::Safe.switch(true)
      rescue => e
        log e.message
      end
    end

    def self.switch (safe_mode, account = nil, user = nil)
      if safe_mode
        cf = ::SwitchUser::ConfigFile.new
        cf.switch(true)
        cf = ::SwitchUser::SshConfigFile.new
        cf.switch(true)
        cf = ::SwitchUser::PkiPublicFile.new
        cf.switch(true)
        cf = ::SwitchUser::PkiPrivateFile.new
        cf.switch(true)
      else
        cf = ::SwitchUser::ConfigFile.new(account, user)
        cf.must_exist
        cf.switch(false)
        cf = ::SwitchUser::SshConfigFile.new(account, user)
        cf.switch(false)
        cf = ::SwitchUser::PkiPublicFile.new(account, user)
        cf.switch(false)
        cf = ::SwitchUser::PkiPrivateFile.new(account, user)
        cf.switch(false)
      end
    end
  end

end
