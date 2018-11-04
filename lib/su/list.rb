require_relative './base'

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
        puts
        data = search_for_users

        data.keys.sort.each do |account|
          users[account].sort.each do |user|
            log "#{account} #{user}"
          end
        end
        puts
      rescue => e
        log e.message
      end
    end
  end

end
