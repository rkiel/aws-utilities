require_relative './file_base'

module SwitchUser
  class SshConfigFile < ::SwitchUser::FileBase

    attr_accessor :access_key_id, :host

    def set ( key , value )
      @data[key] = value
    end

    def export
      if File.exist?(ssh_config_file_name) and not File.exist?(ssh_config_keep_file_name)
        copy(ssh_config_file_name, ssh_config_keep_file_name)
      end
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

    def ssh_config_file_name
      File.join(ssh_root_dir, 'config')
    end

    def ssh_config_keep_file_name
      File.join(ssh_root_dir, 'config.keep.txt')
    end

    def lock_down (file_name)
      File.chmod(0600,file_name)
    end
  end
end
