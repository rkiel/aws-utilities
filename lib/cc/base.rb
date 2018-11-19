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

    def log (msg = "")
      puts msg.gsub(Regexp.new(ENV['HOME']), '~')
    end

    def prompt (data, msg, group, key)
      print "#{msg} [#{data[group][key]}]: "
      answer = gets
      data[group][key] = answer.strip.size > 0 ? answer.strip : data[group][key]
      data
    end

    def answers_path
      home = ENV['HOME']
      File.join(home, '.aws', "codecommit.yml")
    end

    def ssh_file_path (file_name)
      home = ENV['HOME']
      File.join(home, '.ssh', file_name)
    end

    def ssh_config_path
      home = ENV['HOME']
      File.join(home, '.ssh', 'config')
    end

    def get_answers
      region = "us-east-1"
      sshname = "aws-codecommit-#{region}"
      user = ENV['USER']
      home = ENV['HOME']
      default_values = {
        "AWS" => {
          "REPOSITORY" => "my-first-repository",
          "REGION" => region,
          "USER" => user,
          "PROJECTS" => File.join(home,'projects')
        },
        "SSH" => {
          "FILE_NAME" => sshname,
          "TYPE" => "rsa",
          "BITS" => "2048",
          "PASSPHRASE" => "DontUseThisAsYourRealPassphrase",
          "REMOVE" => 'no'
        }
      }
      if File.exist? answers_path
        log "Reading #{answers_path}"
        puts
        data = YAML.load_file(answers_path)
        {
          "AWS" => default_values["AWS"].merge(data["AWS"]),
          "SSH" => default_values["SSH"].merge(data["SSH"])
        }
      else
        log "Creating #{answers_path}"
        File.write(answers_path, default_values.to_yaml)
        lock_down(answers_path)
        log
        default_values
      end
    end

    def save_answers (data)
      log "Saving #{answers_path}"
      File.write(answers_path, data.to_yaml)
      lock_down(answers_path)
      log
    end

    def ssh_add_to_agent (file_name)
      full_ssh_file_path = ssh_file_path(file_name)
      raise "SSH key #{full_ssh_file_path} does not exist" unless File.exist? full_ssh_file_path
      identities = capture_command("ssh-add -l", false).split("\n")
      been_added = identities.reduce(false) { |accum,elem| accum ? accum : elem.include?(full_ssh_file_path) }
      if been_added
        log "SSH key #{full_ssh_file_path} already added to ssh-agent"
      else
        run_command "ssh-add #{full_ssh_file_path}"
      end
    end

    def run_command (cmd)
      log cmd
      system cmd
    end

    def capture_command (cmd, log_command = true)
      log cmd if log_command
      `#{cmd}`
    end

    def remove_file (file_name)
      if File.exist? file_name
        log "Removing #{file_name}"
        File.delete file_name
      end
    end

    def lock_down (file_name)
      log "Locking down #{file_name}"
      File.chmod(0600,file_name)
    end

    def done_message
      log
      log "DONE"
      log
    end

    def error_message(e)
      log
      log "ERROR: #{e.message}"
      log
    end

  end

end
