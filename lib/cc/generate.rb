require_relative './base'

module CodeCommit

  class Generate < CodeCommit::Base

    def valid?
      argv.size == 1
    end

    def help
      "#{script_name} generate"
    end

    def execute
      action = argv.shift

      begin
        puts
        answers = get_answers
        prompt answers, "AWS User Name", "AWSUSER"
        prompt answers, "SSH File Name", "SSHNAME"
        prompt answers, "SSH Key Type", "SSHTYPE"
        prompt answers, "SSH Key Bit Strength", "SSHBITS"
        prompt answers, "SSH Passphrase", "SSHPASSPHRASE"
        save_answers answers

        awsuser       = answers['AWSUSER']
        sshname       = answers['SSHNAME']
        sshtype       = answers['SSHTYPE']
        sshbits       = answers['SSHBITS']
        sshpassphrase = answers['SSHPASSPHRASE']
        sshfile       = answers['SSHFILE']

        puts
        puts "Creating cryptologic keys"
        puts
        remove_file sshfile
        remove_file sshfile + '.pub'
        run_command "ssh-keygen -b #{sshbits} -t #{sshtype} -f #{sshfile} -C #{sshname} -P '#{sshpassphrase}'"
        lock_down sshfile
        lock_down sshfile + '.pub'

        puts
        puts "Uploading public key"
        puts
        run_command "aws iam upload-ssh-public-key --user-name #{awsuser} --ssh-public-key-body \"$(cat #{sshfile}.pub)\""

        puts
        puts "DONE"
        puts
      rescue => e
        puts e.message
      end
    end
  end

end
