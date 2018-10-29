require_relative './base'

module SwitchUser

  class Export < SwitchUser::Base

    def valid?
      argv.size == 1
    end

    def help
      "#{script_name} export"
    end

    def execute
      begin
        file_name = File.join(aws_root_dir,'credentials')
        credentials = read_file file_name

        file_name = File.join(aws_root_dir,'config')
        config = read_file file_name

        keys = (credentials.keys + config.keys).uniq

        keys.each do |key|
          print "Enter Account & User for #{key} "
          x = STDIN.gets
          y = x.split(/\s+/).map {|z| z.strip}
          account = y[0]
          user = y[1]

          base_dir = create_path account, user
          file_name = File.join(base_dir, 'credentials')
          export_file file_name, credentials[key]

          file_name = File.join(base_dir, 'config')
          export_file file_name, config[key]
        end
      rescue => e
        log e.message
      end
    end
  end

end
