require_relative './base'
require_relative './config_file'
require_relative './csv_file'

module SwitchUser

  class Add < SwitchUser::Base

    def valid?
      argv.size == 6
    end

    def help
      "#{script_name} add account user pathToCsvFile region output"
    end

    def execute
      action = argv.shift
      account = argv.shift
      user = argv.shift
      path_to_csv_file = argv.shift
      region = argv.shift
      output = argv.shift

      begin
        csv = ::SwitchUser::CsvFile.new(path_to_csv_file)
        csv.must_exist
        csv.parse

        cf = ::SwitchUser::ConfigFile.new(account, user)
        cf.must_not_exist
        cf.aws_access_key_id = csv.access_key_id
        cf.aws_secret_access_key = csv.secret_access_key
        cf.region = region
        cf.output = output
        cf.save

        csv.remove
      rescue => e
        log e.message
      end
    end
  end

end
