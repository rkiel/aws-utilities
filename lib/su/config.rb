require_relative './base'
require_relative './config_file'

module SwitchUser

  class Config < SwitchUser::Base

    def valid?
      argv.size == 5
    end

    def help
      "#{script_name} config account user region output"
    end

    def execute
      action = argv.shift
      account = argv.shift
      user = argv.shift
      region = argv.shift
      output = argv.shift

      begin
        cf = ::SwitchUser::ConfigFile.new(account, user)
        cf.must_exist
        cf.region = region
        cf.output = format
        cf.save
      rescue => e
        log e.message
      end
    end
  end

end
