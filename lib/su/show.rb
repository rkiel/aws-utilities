require_relative './base'

module SwitchUser

  class Show < SwitchUser::Base

    def valid?
      argv.size == 1
    end

    def help
      "#{script_name} show"
    end

    def execute

      begin
        ['credentials','config'].each do |name|
          puts
          file_name = File.join(aws_root_dir,name)
          file_must_exist file_name
          system "cat #{file_name}"
        end
        puts
      rescue => e
        log e.message
      end
    end
  end

end
