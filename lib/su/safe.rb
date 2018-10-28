require_relative './base'

module SwitchUser

  class Safe < SwitchUser::Base

    def valid?
      argv.size == 1
    end

    def help
      "#{script_name} safe"
    end

    def execute

      begin
        ['credentials','config'].each do |name|
          file_name = File.join(aws_root_dir, name)
          if File.exist? file_name
            log "Removing #{file_name}"
            File.delete file_name
          end
        end
      rescue => e
        log e.message
      end
    end
  end

end
