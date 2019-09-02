require_relative './base'

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
        puts
        file_name = json_name(account, user)
        file_must_exist file_name
        log "Updating #{file_name}"
        json_hash = read_json file_name
        json_hash["region"] = region
        json_hash["output"] = output
        write_json(file_name, json_hash)
        puts
      rescue => e
        log e.message
      end
    end
  end

end
