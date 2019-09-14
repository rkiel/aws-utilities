require_relative './file_base'

module SwitchUser
  class PkiPublicFile < ::SwitchUser::FileBase

    def load
    end

    def save
    end

    private

    def file_name
      @file_name ||= begin
        name = 'codecommit_id_rsa'
        name = [name,'pub'].join('.')
        File.join(awssu_root_dir, account, user, name)
      end
    end

  end
end
