require_relative './base'

module SwitchUser

  class Config < SwitchUser::Base

    def valid?
      argv.size == 5
    end

    def help
      "#{script_name} add config user region format"
    end

    def execute
      action = argv.shift
      account = argv.shift
      user = argv.shift
      region = argv.shift
      format = argv.shift

      begin
        base_dir = File.join(awssu_root_dir,account,user)

        puts
        file_name = File.join(base_dir, 'config')
        file_must_exist file_name
        log "Updating #{file_name}"
        write_config file_name, account, user, region, format
        puts
      rescue => e
        log e.message
      end
    end
  end

end
