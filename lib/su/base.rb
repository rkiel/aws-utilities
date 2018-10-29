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

    def legacy account, user
      src_file_name = File.join(aws_root_dir,'credentials')
      dest_file_name = File.join(awssu_root_dir,account,user,'credentials')
      if not File.exist? src_file_name
        raise "ERROR: #{src_file_name} does not exist"
      elsif File.exist? dest_file_name
        raise "ERROR: #{dest_file_name} already exists"
      else
        FileUtils.cp src_file_name, dest_file_name
        File.chmod(0600, dest_file_name)
      end

      src_file_name =  File.join(aws_root_dir,'config')
      dest_file_name = File.join(awssu_root_dir,account,user,'config')
      if not File.exist? src_file_name
        raise "ERROR: #{src_file_name} does not exist"
      elsif File.exist? dest_file_name
        raise "ERROR: #{dest_file_name} already exists"
      else
        FileUtils.cp src_file_name, dest_file_name
        File.chmod(0600, dest_file_name)
      end
    end

  end

end
