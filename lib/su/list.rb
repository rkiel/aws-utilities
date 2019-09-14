require_relative './base'
require_relative './config_file'

module SwitchUser

  class List < SwitchUser::Base

    def valid?
      argv.size == 1
    end

    def help
      "#{script_name} list"
    end

    def execute

      begin
        data = ::SwitchUser::ConfigFile.new.search

        data.keys.sort.each do |account|
          data[account].sort.each do |user|
            log "#{user.awssu_account} #{user.awssu_user}"
          end
        end
      rescue => e
        log e.message
      end
    end
  end

end
