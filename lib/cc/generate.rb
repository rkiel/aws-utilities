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
        aws = answers['AWS']
        ssh = answers['SSH']

        prompt answers, "AWS User Name",        "AWS", "USER"
        prompt answers, "SSH File Name",        "SSH", "FILE_NAME"
        prompt answers, "SSH Key Type",         "SSH", "TYPE"
        prompt answers, "SSH Key Bit Strength", "SSH", "BITS"
        prompt answers, "SSH Passphrase",       "SSH", "PASSPHRASE"
        save_answers answers

        user       = aws['USER']
        file_name  = ssh['FILE_NAME']
        type       = ssh['TYPE']
        bits       = ssh['BITS']
        passphrase = ssh['PASSPHRASE']
        file_path  = ssh_file_path(file_name)

        puts
        puts "Creating cryptologic keys"
        puts
        remove_file file_path
        remove_file file_path + '.pub'
        run_command "ssh-keygen -b #{bits} -t #{type} -f #{file_path} -C #{file_name} -P '#{passphrase}'"

        puts
        lock_down file_path
        lock_down file_path + '.pub'

        puts
        puts "Uploading public key"
        puts
        run_command "aws iam upload-ssh-public-key --user-name #{user} --ssh-public-key-body \"$(cat #{file_path}.pub)\""

        done_message
      rescue => e
        error_message(e)
      end
    end
  end

end
