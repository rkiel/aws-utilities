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

    def aws_root_dir
      File.join(ENV['HOME'], '.aws')
    end

    def awssu_root_dir
#      File.join(aws_root_dir,'awssu')
      File.join(ENV['HOME'], '.awssu')
    end

    def ssh_root_dir
      File.join(ENV['HOME'], '.ssh')
    end

    def mkdir (path)
      FileUtils.mkdir_p(path)
      File.chmod(0700, path)
    end

    def lock_down (file_name)
      File.chmod(0600,file_name)
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

    def json_keys
      [
        "awssu_account",
        "awssu_user",
        "aws_access_key_id",
        "aws_secret_access_key",
        "region",
        "output"
      ]
    end

    def create_json (account, user, access_key_id, secret_access_key, region, format)
      {
        "awssu_account": account,
        "awssu_user": user,
        "aws_access_key_id": access_key_id,
        "aws_secret_access_key": secret_access_key,
        "region": region,
        "output": format
      }
    end

    def create_pki(file_name,passphrase, comment)
      [
        "ssh-keygen -f #{file_name} -P '#{passphrase.strip}' -m PEM -t rsa -b 4096 -C '#{comment.strip}' -q"
      ].each do |cmd|
        puts
        puts cmd
        system cmd
      end
      puts
    end

    def write_ssh_config (file_name, access_key_id)
      lines = []
      lines << "Host git-codecommit.*.amazonaws.com"
      lines << "  User #{access_key_id}"
      lines << "  IdentityFile #{ssh_root_dir}/codecommit"
      File.write(file_name, lines.join("\n"))
      lock_down file_name
    end

    def write_json (file_name, json_hash)
      File.write(file_name, JSON.pretty_generate(json_hash))
      lock_down file_name
    end

    def read_json (file_name)
      JSON.parse(File.read(file_name))
    end

    def ssh_config_name(account, user)
      #file_name = [account,user, 'ssh','config'].join('_')
      file_name = ['ssh','config'].join('_')
      file_name = [file_name,'txt'].join('.')
      File.join(awssu_root_dir, account, user, file_name)
    end

    def json_name(account, user)
      #file_name = [account,user, 'awssu'].join('_')
      file_name = 'configure'
      file_name = [file_name,'json'].join('.')
      File.join(awssu_root_dir, account, user, file_name)
    end

    def pki_name(account, user)
      #file_name = [account,user,"id","rsa"].join('_')
      file_name = ["codecommit"].join('-')
      File.join(awssu_root_dir, account, user, file_name)
    end

    def list_directory (*path)
      if Dir.exist? File.join(path)
        Dir.new(File.join(path)).reject {|x| ['.','..'].include? x}
      else
        []
      end
    end

    def switch_user (account, user)
      file_name = json_name(account, user)
      file_must_exist file_name
      json_hash = read_json(file_name)
      set_user(json_hash)
    end

    def set_user (json_hash)
      json_keys.each do |key|
          default_value = "SAFE_#{key.upcase}"
          cmd = "aws configure set #{key} #{json_hash[key] || default_value}"
          puts cmd
          system cmd
      end
    end

    def get_user (profile = "default")
      json_hash = {}
      json_keys.each do |key|
          cmd = "aws configure get #{key} --profile #{profile}"
          puts cmd
          json_hash[key] = `#{cmd}`.strip
      end
      json_hash
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

    def safe_mode
      set_user({})
    end

  end

end
