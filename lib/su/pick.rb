require_relative './base'
require_relative './config_file'

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
        data = search_for_users

        accounts = []
        data.keys.each do |account|
          data[account].each do |user|
            accounts << account if user == switch_to_user
          end
        end

        if accounts.size == 0
          raise "#{switch_to_user} not found"
        elsif accounts.size == 1
          cf = ::SwitchUser::ConfigFile.new(accounts.first, switch_to_user)
          cf.must_exist
          cf.switch(false)
        else
          cf = ::SwitchUser::ConfigFile.new
          cf.switch(true)
          accounts.sort.each do |account|
            log "#{account} #{switch_to_user}"
          end
        end
      rescue => e
        log e.message
        cf = ::SwitchUser::ConfigFile.new
        cf.switch(true)
      end
    end
  end

end
