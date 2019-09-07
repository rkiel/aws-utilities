require_relative './base'
require_relative './config_file'
require_relative './ssh_config_file'
require_relative './csv_file'

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
      path_to_csv_file = argv.shift
      region = argv.shift
      format = argv.shift

      begin
        base_dir = create_path account, user

        csv = ::SwitchUser::CsvFile.new(path_to_csv_file)
        csv.must_exist
        csv.parse

        cf = ::SwitchUser::ConfigFile.new(account, user)
        cf.must_not_exist
        cf.set_access_key(csv.access_key_id)
        cf.set_secret_access_key(csv.secret_access_key)
        cf.set_region(region)
        cf.set_output(format)
        cf.save

        ssh = ::SwitchUser::SshConfigFile.new(account, user)
        ssh.must_not_exist
        ssh.access_key_id = csv.access_key_id
        ssh.save

        csv.remove
        puts
      rescue => e
        log e.message
      end
    end
  end

end
