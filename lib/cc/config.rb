require 'json'
require_relative './base'

module CodeCommit

  class Config < CodeCommit::Base

    def valid?
      argv.size == 1
    end

    def help
      "#{script_name} config"
    end

    def execute
      action = argv.shift

      begin
        puts
        answers = get_answers
        prompt answers, "AWS User Name", "AWSUSER"
        prompt answers, "Remove SSH config", "REMOVECONFIG"
        prompt answers, "Repository in AWS Region", "AWSREGION"
        prompt answers, "SSH File Name", "SSHNAME"

        awsuser       = answers['AWSUSER']

        puts
        puts "Retrieving public key id"
        output = `aws iam list-ssh-public-keys --user-name #{awsuser}`
        json = JSON.parse(output)
        keys = json["SSHPublicKeys"]

        if keys.size < 1
          raise "No keys found"
        elsif keys.size > 1
          ids = keys. map { |x| x['SSHPublicKeyId'] }
          puts "More than 1 Id found.  Please choose:"
          ids.each { |id| puts "  #{id}"}
          prompt answers, "AWS SSH Id", "AWSSSHID"
        else
          ids = keys. map { |x| x['SSHPublicKeyId'] }
          answers['AWSSSHID'] = ids.first
        end

        aws_ssh_id = answers['AWSSSHID']
        sshname    = answers['SSHNAME']
        home = ENV['HOME']
        sshfile = File.join(home, '.ssh', sshname)
        answers["SSHFILE"] = sshfile

        save_answers answers

        removeconfig  = answers['REMOVECONFIG']
        sshconfig     = answers['SSHCONFIG']
        aws_region = answers['AWSREGION']

        remove_file sshconfig if removeconfig == 'yes'

        puts
        puts "Updating #{sshconfig}"
        puts
        open(sshconfig, 'a') do |f|
          [
            "Host git-codecommit.#{aws_region}.amazonaws.com",
            "  User #{aws_ssh_id}",
            "  IdentityFile #{sshfile}"
          ].each do |line|
              puts line
            f.puts line
          end
        end
        lock_down sshconfig

        puts
        puts "DONE"
        puts
      rescue => e
        puts e.message
      end
    end
  end

end
