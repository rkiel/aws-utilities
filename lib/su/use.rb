require_relative './base'

module SwitchUser

  class Use < SwitchUser::Base

    def valid?
      argv.size == 3
    end

    def help
      "#{script_name} use account user"
    end

    def execute
      action = argv.shift
      account = argv.shift
      user = argv.shift

      begin
        puts
        ['credentials','config'].each do |name|
          src_file_name = File.join(awssu_root_dir,account,user, name)
          dest_file_name = File.join(aws_root_dir, name)
          file_must_exist src_file_name
          log "Replacing #{dest_file_name}"
          copy src_file_name, dest_file_name
        end
        puts
      rescue => e
        log e.message
      end
    end
  end

end
