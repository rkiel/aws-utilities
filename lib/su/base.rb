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

    def file_must_exist (file_name)
      raise "ERROR: #{file_name} does not exists" unless File.exist? file_name
    end

    def file_not_must_exist (file_name)
      raise "ERROR: #{file_name} already exists" if File.exist? file_name
    end

    def log (msg)
      puts msg.gsub(Regexp.new(ENV['HOME']), '~')
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


    def remove account, user
      file_name = File.join(awssu_root_dir,account,user,'credentials')
      if File.exist? file_name
        puts "Removing #{file_name}"
        File.delete file_name
      else
        puts "Missing #{file_name}"
      end

      file_name = File.join(awssu_root_dir,account,user,'config')
      if File.exist? file_name
        puts "Removing #{file_name}"
        File.delete file_name
      else
        puts "Missing #{file_name}"
      end
    end

    def use account, user
      src_file_name = File.join(awssu_root_dir,account,user,'credentials')
      dest_file_name = File.join(aws_root_dir,'credentials')
      if File.exist? src_file_name
        puts "Replacing #{dest_file_name}"
        FileUtils.cp src_file_name, dest_file_name
        File.chmod(0600, dest_file_name)
      else
        raise "ERROR: #{src_file_name} does not exists"
      end

      src_file_name = File.join(awssu_root_dir,account,user,'config')
      dest_file_name =  File.join(aws_root_dir,'config')
      if File.exist? src_file_name
        puts "Replacing #{dest_file_name}"
        FileUtils.cp src_file_name, dest_file_name
        File.chmod(0600, dest_file_name)
      else
         raise "ERROR: #{src_file_name} does not exists"
      end
    end

    def show
      puts

      file_name = File.join(aws_root_dir,'credentials')
      if File.exist? file_name
        system "cat #{file_name}"
      else
        puts "ERROR: #{file_name} does not exists"
      end

      puts

      file_name = File.join(aws_root_dir,'config')
      if File.exist? file_name
        system "cat #{file_name}"
      else
         puts "ERROR: #{file_name} does not exists"
      end

      puts
    end

    def safe
      file_name = File.join(aws_root_dir,'credentials')
      if File.exist? file_name
        puts "Removing #{file_name}"
        File.delete file_name
      end

      file_name = File.join(aws_root_dir,'config')
      if File.exist? file_name
        puts "Removing #{file_name}"
        File.delete file_name
      end
    end

    def list
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
          puts "#{account} #{user}"
        end
      end
    end


  end

end
