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
        ['credentials','config'].each do |name|
          file_name = File.join(awssu_root_dir,account,user,name)
          file_must_exist file_name
          log "Removing #{file_name}"
          File.delete file_name
        end
        puts
      rescue => e
        log e.message
      end
    end
  end

end
