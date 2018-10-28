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
        users = Hash.new

        Dir.chdir(awssu_root_dir) do
          Dir['*'].each do |account|
            users[account] = []
          end
        end

        users.keys.each do |account|
          Dir.chdir(File.join(awssu_root_dir,account)) do
            Dir['*'].each do |user|
              base_dir = File.join(awssu_root_dir,account,user)
              users[account] << user if File.exist? File.join(base_dir,'credentials') and File.exist? File.join(base_dir,'config')
            end
          end
        end

        users.keys.sort.each do |account|
          users[account].each do |user|
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
