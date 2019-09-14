require_relative './base'
require_relative './safe'

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
      switch_to_user = argv.shift

      begin
        data = ::SwitchUser::ConfigFile.new.search

        accounts = []
        data.keys.each do |account|
          data[account].each do |user|
            accounts << account if user.awssu_user == switch_to_user
          end
        end

        if accounts.size == 0
          raise "#{switch_to_user} not found"
        elsif accounts.size == 1
          ::SwitchUser::Safe.switch(false, accounts.first, switch_to_user)
        else
          accounts.sort.each do |account|
            log "#{account} #{switch_to_user}"
          end
          ::SwitchUser::Safe.switch(true)
        end
      rescue => e
        log e.message
        ::SwitchUser::Safe.switch(true)
      end
    end
  end

end
