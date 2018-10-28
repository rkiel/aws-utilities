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

        file_name = File.join(base_dir, 'config')
        file_must_exist file_name
        log "Updating #{file_name}"
        File.open(file_name, "w") do |f|
          f.puts ";"
          f.puts "; #{account} #{user}"
          f.puts ";"
          f.puts "[default]"
          f.puts "region = #{region}"
          f.puts "output = #{format}"
        end
        lock_down file_name
      rescue => e
        log e.message
      end
    end
  end

end
