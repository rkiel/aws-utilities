require 'yaml'
require 'fileutils'

module CodeCommit

  class Base

    attr_reader :argv

    def initialize (argv)
      @argv = argv
    end

    def script_name
      "codecommit"
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

    def prompt (data, msg, key)
      print "#{msg} [#{data[key]}]: "
      answer = gets
      data[key] = answer.strip.size > 0 ? answer.strip : data[key]
      data
    end

    def get_answers
      file_name = 'answers.yml'

      region = "us-east-1"
      sshname = "aws-codecommit-#{region}"
      user = ENV['USER']
      home = ENV['HOME']
      default_values = {
        "AWSREPO" => "my-first-repository",
        "AWSREGION" => region ,
        "AWSUSER" => user,
        "SSHNAME" => sshname,
        "SSHTYPE" => "rsa",
        "SSHBITS" => "2048",
        "SSHPASSPHRASE" => "DontUseThisAsYourRealPassphrase",
        "SSHFILE" => File.join(home, '.ssh', sshname),
        "SSHCONFIG" => File.join(home, '.ssh', 'config'),
        "REMOVECONFIG" => 'no'
      }

      if File.exist? file_name
        puts "Reading #{file_name}"
        puts
        data = YAML.load_file(file_name)
        default_values.merge(data)
      else
        puts "Creating #{file_name}"
        puts
        File.write(file_name, default_values.to_yaml)
        FileUtils.chmod(0600, file_name)
        default_values
      end
    end

    def save_answers (data)
      file_name = 'answers.yml'
      puts "Saving #{file_name}"
      puts
      File.write(file_name, data.to_yaml)
      FileUtils.chmod(0600, file_name)
    end

    def run_command (cmd)
      puts cmd
      system cmd
    end

    def remove_file (file_name)
      if File.exist? file_name
        log "Removing #{file_name}"
        File.delete file_name
      end
    end

    def lock_down (file_name)
      log "Lock down #{file_name}"
      File.chmod(0600,file_name)
    end

  end

end
