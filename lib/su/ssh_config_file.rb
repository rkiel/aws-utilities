require_relative './file_base'

module SwitchUser
  class SshConfigFile < ::SwitchUser::FileBase

    attr_accessor :access_key_id, :host

    def set ( key , value )
      @data[key] = value
    end

  private

    def set_file_contents(contents)
      @host = "git-codecommit.*.amazonaws.com"
      @data = {}
    end

    def get_file_contents
      set "User", access_key_id
      set "IdentityFile",  "~/.ssh/codecommit_id_rsa"

      lines = []
      lines << "Host #{host}"
      @data.each do |key, value|
        lines << "  #{key} #{value}"
      end
      lines.join("\n")
    end

    def file_name
      @file_name ||= begin
      #name = [account,user, 'awssu'].join('_')
        name = 'ssh_config'
        name = [name,'txt'].join('.')
        File.join(awssu_root_dir, account, user, name)
      end
    end
  end
end
