require_relative './file_base'

module SwitchUser
  class PkiPrivateFile < ::SwitchUser::FileBase

    def load
    end

    def save
    end

    def generate(passphrase, comment)
      create_pki(prompt("PKI passphrase: ",passphrase), prompt("PKI comment: ",comment))
    end

    private

    def prompt(msg, value)
      if value
        value
      else
        print msg
        gets.chomp
      end
    end

    def create_pki(passphrase, comment)
      [
        "ssh-keygen -f #{file_name} -P '#{passphrase.strip}' -m PEM -t rsa -b 4096 -C '#{comment.strip}' -q"
      ].each do |cmd|
        puts
        puts cmd
        system cmd
      end
    end

    def file_name
      @file_name ||= begin
        name = 'codecommit_id_rsa'
        File.join(awssu_root_dir, account, user, name)
      end
    end

  end
end
