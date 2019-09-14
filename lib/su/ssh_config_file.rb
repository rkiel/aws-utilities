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

    def switch(safe_mode = true)
      if safe_mode
        if File.exist?(ssh_config_keep_file_name)
          copy(ssh_config_keep_file_name, ssh_config_file_name)
        elsif File.exist?(ssh_config_file_name)
          File.delete ssh_config_file_name
        end
      else
        if File.exist?(file_name)
          if File.exist?(ssh_config_keep_file_name)
            copy(file_name, ssh_config_file_name)
            system "echo >> #{ssh_config_file_name}"
            system "cat #{ssh_config_keep_file_name} >> #{ssh_config_file_name}"
            system "echo >> #{ssh_config_file_name}"
            lock_down ssh_config_file_name
          else
            copy(file_name, ssh_config_file_name)
          end
        elsif File.exist?(ssh_config_keep_file_name)
          copy(ssh_config_keep_file_name, ssh_config_file_name)
        end
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

    def copy (src_path, dest_path)
      log "Copying to #{dest_path}"
      FileUtils.copy(src_path, dest_path)
      lock_down dest_path
    end
  end
end
