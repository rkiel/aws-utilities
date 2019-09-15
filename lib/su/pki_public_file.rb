require_relative './file_base'

module SwitchUser
  class PkiPublicFile < ::SwitchUser::FileBase

    def load
    end

    def save
    end

    def switch (safe_mode)
      if safe_mode
        if File.exist? ssh_file_name
          File.delete ssh_file_name
        end
      else
        copy(file_name, ssh_file_name)
      end
    end

    private

    def file_name
      @file_name ||= begin
        File.join(awssu_root_dir, account, user, full_id_rsa)
      end
    end

    def ssh_file_name
      File.join(ssh_root_dir, full_id_rsa)
    end

    def id_rsa
      'codecommit_id_rsa'
    end

    def full_id_rsa
      [id_rsa,'pub'].join('.')
    end

  end
end
