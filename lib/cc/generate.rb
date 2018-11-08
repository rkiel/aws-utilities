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

        puts
        puts "DONE"
        puts
      rescue => e
        puts e.message
      end
    end
  end

end
