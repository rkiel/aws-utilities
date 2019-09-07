require 'csv'
require 'fileutils'
require 'json'

module SwitchUser

  class Base

    attr_reader :argv

    def initialize (argv)
      @argv = argv
    end

    def script_name
      "awssu"
    end

    def valid?
      false
    end

    def help
      "TBD"
    end

    def usage
      puts
      puts "USAGE: #{help}"
      puts
      exit
    end

    def execute

    end

    def log (msg)
      puts msg.gsub(Regexp.new(ENV['HOME']), '~')
    end

    def json_name(account, user)
      #file_name = [account,user, 'awssu'].join('_')
      file_name = 'configure'
      file_name = [file_name,'json'].join('.')
      File.join(awssu_root_dir, account, user, file_name)
    end

    def list_directory (*path)
      if Dir.exist? File.join(path)
        Dir.new(File.join(path)).reject {|x| ['.','..'].include? x}
      else
        []
      end
    end

    def search_for_users
      users = Hash.new

      Dir.chdir(awssu_root_dir) do
        Dir['*'].each do |account|
          users[account] = []
        end
      end

      users.keys.each do |account|
        Dir.chdir(File.join(awssu_root_dir,account)) do
          Dir['*'].each do |user|
            users[account] << user if File.exist? json_name(account,user)
          end
        end
      end

      users
    end

    def search_for_unique_users
      data = search_for_users

      users = []
      data.keys.each do |account|
        data[account].each do |user|
          users << user
        end
      end

      users.uniq.reject do |user|
        user_list = users.select { |u| u == user }
        user_list.size > 1
      end

    end

  end

end
