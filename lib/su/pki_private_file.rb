require_relative './pki_public_file'

module SwitchUser
  class PkiPrivateFile < ::SwitchUser::PkiPublicFile

    def generate(passphrase, comment)
      passphrase = prompt("PKI passphrase: ",passphrase)
      comment = prompt("PKI comment: ",comment)
      create_pki(passphrase, comment)
    end

    def something
      cmd = "aws iam upload-ssh-public-key --user-name #{user} --ssh-public-key-body \"$(cat #{file_name}.pub)\""
      output = `#{cmd}`
      json = JSON.parse(output)
      json["SSHPublicKey"]["SSHPublicKeyId"]
    end

    private

    def full_id_rsa
      id_rsa
    end

    def prompt(msg, value = nil)
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
