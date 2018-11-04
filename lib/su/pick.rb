require_relative './base'

module SwitchUser

  class Pick < SwitchUser::Base

    def valid?
      argv.size == 2
    end

    def help
      "#{script_name} pick user"
    end

    def execute
      action = argv.shift
      swithToUser = argv.shift

      begin
        puts
        data = search_for_users

        accounts = []
        data.keys.each do |account|
          data[account].each do |user|
            accounts << account if user == swithToUser
          end
        end

        if accounts.size == 0
          raise "#{swithToUser} not found"
        elsif accounts.size == 1
          switchUser accounts.first, swithToUser
        else
          accounts.sort.each do |account|
            log "#{account} #{swithToUser}"
          end
        end
        puts
      rescue => e
        log e.message
      end
    end
  end

end
