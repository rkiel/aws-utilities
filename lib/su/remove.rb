require_relative './base'
require_relative './config_file'
require_relative './ssh_config_file'
require_relative './pki_public_file'
require_relative './pki_private_file'

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
        cf = ::SwitchUser::ConfigFile.new(account, user)
        cf.remove

        ssh = ::SwitchUser::SshConfigFile.new(account, user)
        ssh.remove

        pki_public = ::SwitchUser::PkiPublicFile.new(account, user)
        pki_public.remove

        pki_private = ::SwitchUser::PkiPrivateFile.new(account, user)
        pki_private.remove
      rescue => e
        log e.message
      end
    end

    def purge_dir (*path)
      dir_name = File.join(path)
      log "Removing #{dir_name}"
      Dir.delete dir_name
    end
  end

end
