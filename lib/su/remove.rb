require_relative './base'

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

        puts
        file_name = json_name(account,user)
        file_must_exist file_name
        log "Removing #{file_name}"
        File.delete file_name

        purge_dir(awssu_root_dir, account, user)
        dirs = list_directory(awssu_root_dir, account)
        purge_dir(awssu_root_dir, account) if dirs.empty?

        puts
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
