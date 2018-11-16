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
        aws  = answers['AWS']
        ssh  = answers['SSH']
        
        prompt answers, "AWS User Name",            "AWS", "USER"
        prompt answers, "Repository in AWS Region", "AWS", "REGION"
        prompt answers, "SSH File Name",            "SSH", "FILE_NAME"
        prompt answers, "Remove SSH config",        "SSH", "REMOVE"

        user = aws['USER']

        puts
        puts "Retrieving public key id"
        output = capture_command "aws iam list-ssh-public-keys --user-name #{user}"
        json = JSON.parse(output)
        keys = json["SSHPublicKeys"]

        if keys.size < 1
          raise "No keys found"
        elsif keys.size > 1
          ids = keys. map { |x| x['SSHPublicKeyId'] }
          puts "More than 1 Id found.  Please choose:"
          ids.each { |id| puts "  #{id}"}
          prompt answers, "AWS SSH Id", "AWS", "SSHID"
        else
          ids = keys. map { |x| x['SSHPublicKeyId'] }
          aws['SSHID'] = ids.first
        end

        save_answers answers

        aws_ssh_id = aws['SSHID']
        sshfile = ssh_file_path(ssh['FILE_NAME'])


        sshconfig     = ssh_config_path
        removeconfig  = ssh['REMOVE']
        remove_file sshconfig if removeconfig == 'yes'

        puts
        log "Updating #{sshconfig}"
        puts
        aws_region = aws['REGION']
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

        puts
        lock_down sshconfig

        done_message
      rescue => e
        error_message(e)
      end
    end
  end

end
