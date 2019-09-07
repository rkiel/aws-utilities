require_relative './base'
require_relative './config_file'
require_relative './pki_public_file'
require_relative './pki_private_file'

module SwitchUser

  class Pki < SwitchUser::Base

    def valid?
      argv.size > 2
    end

    def help
      "#{script_name} pki account user [passphrase [comment]]"
    end

    def execute
      action = argv.shift
      account = argv.shift
      user = argv.shift
      passphrase = argv.shift
      comment = argv.shift

      begin
        pki_public = ::SwitchUser::PkiPublicFile.new(account, user)
        pki_public.must_not_exist

        pki_private = ::SwitchUser::PkiPrivateFile.new(account, user)
        pki_private.must_not_exist
        pki_private.generate(passphrase, comment)

        cf = ::SwitchUser::ConfigFile.new(account, user)
        cf.must_exist
        cf.awssu_pki = true
        cf.save
      rescue => e
        log e.message
      end
    end
  end

end
