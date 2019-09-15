require_relative './pki_public_file'

module SwitchUser
  class PkiPrivateFile < ::SwitchUser::PkiPublicFile

    def generate(passphrase, comment)
      create_pki(prompt("PKI passphrase: ",passphrase), prompt("PKI comment: ",comment))
    end

    private

    def full_id_rsa
      id_rsa
    end

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

  end
end
