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

    def prompt (data, msg, key)
      print "#{msg} [#{data[key]}]: "
      answer = gets
      data[key] = answer.strip.size > 0 ? answer.strip : data[key]
      data
    end

    def get_answers
      file_name = 'answers.yml'
      if File.exist? file_name
        puts "Reading #{file_name}"
        puts
        YAML.load_file(file_name)
      else
        puts "Creating #{file_name}"
        puts
        data = {
          "AWSREPO" => "my-first-repository",
          "AWSREGION" => "us-east-1"
        }
        File.write(file_name, data.to_yaml)
        FileUtils.chmod(0600, file_name)
        data
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

  end

end
