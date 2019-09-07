require_relative './base'
require_relative './config_file'

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
        puts
        create_path account, user

        file_name = pki_name(account, user)
        file_not_must_exist file_name
        file_not_must_exist "#{file_name}.pub"

        unless passphrase
          print "PKI passphrase: "
          passphrase = gets.chomp
        end
        unless comment
          print "PKI comment: "
          comment = gets.chomp
        end
        create_pki(file_name, passphrase, comment)

        cf = ::SwitchUser::ConfigFile.new(account, user)
        cf.must_exist
        cf.awssu_pki = true
        cf.save

        puts
      rescue => e
        log e.message
      end
    end
  end

end
