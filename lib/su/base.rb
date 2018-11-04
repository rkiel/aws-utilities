require 'csv'
require 'fileutils'

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

    def aws_root_dir
      File.join(ENV['HOME'], '.aws')
    end

    def awssu_root_dir
      File.join(aws_root_dir,'awssu')
    end

    def mkdir (path)
      FileUtils.mkdir_p(path)
      File.chmod(0700, path)
    end

    def lock_down (file_name)
      File.chmod(0600,file_name)
    end

    def copy src_file_name, dest_file_name
      FileUtils.cp src_file_name, dest_file_name
      File.chmod(0600, dest_file_name)
    end

    def file_must_exist (file_name)
      raise "ERROR: #{file_name} does not exists" unless File.exist? file_name
    end

    def file_not_must_exist (file_name)
      raise "ERROR: #{file_name} already exists" if File.exist? file_name
    end

    def log (msg)
      puts msg.gsub(Regexp.new(ENV['HOME']), '~')
    end

    def create_path (account, user)
      base_dir = File.join(awssu_root_dir)
      mkdir(base_dir)
      base_dir = File.join(awssu_root_dir,account)
      mkdir(base_dir)
      base_dir = File.join(awssu_root_dir,account,user)
      mkdir(base_dir)
      puts
      log "Created #{base_dir}"
      base_dir
    end

    def write_credentials (file_name, account, user, access_key_id, secret_access_key)
      File.open(file_name, "w") do |f|
        f.puts ";"
        f.puts "; #{account} #{user} credentials"
        f.puts ";"
        f.puts "[default]"
        f.puts "aws_access_key_id = #{access_key_id}"
        f.puts "aws_secret_access_key = #{secret_access_key}"
      end
      lock_down file_name
    end

    def write_config (file_name, account, user, region, format)
      File.open(file_name, "w") do |f|
        f.puts ";"
        f.puts "; #{account} #{user} config"
        f.puts ";"
        f.puts "[default]"
        f.puts "region = #{region}"
        f.puts "output = #{format}"
      end
      lock_down file_name
    end

    def export_file (file_name, data)
      file_not_must_exist file_name
      log "Adding #{file_name}"
      File.write(file_name, data.join("\n"))
      lock_down file_name
    end

    def read_file (file_name)
      contents = File.read(file_name)
      lines = contents.split("\n")
      lines = lines.map { |x| x.strip }
      lines = lines.reject { |x| x.match(/^;/) }
      lines = lines.map { |x| x.sub("[profile ","[") }
      section = nil
      data = {}
      lines.each do |line|
        if line.match(/\[.+\]/)
          section = line
          data[section] = []
        else
          data[section].push line
        end
      end
      data
    end

    def list_directory (*path)
      if Dir.exist? File.join(path)
        Dir.new(File.join(path)).reject {|x| ['.','..'].include? x}
      else
        []
      end
    end

    def switchUser (account, user)
      ['credentials','config'].each do |name|
        src_file_name = File.join(awssu_root_dir,account,user, name)
        dest_file_name = File.join(aws_root_dir, name)
        file_must_exist src_file_name
        log "Replacing #{dest_file_name}"
        copy src_file_name, dest_file_name
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
            base_dir = File.join(awssu_root_dir,account,user)
            users[account] << user if File.exist? File.join(base_dir,'credentials') and File.exist? File.join(base_dir,'config')
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
