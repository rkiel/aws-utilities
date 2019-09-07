require_relative './file_base'

module SwitchUser
  class SshConfigFile < ::SwitchUser::FileBase

    attr_accessor :access_key_id

  private

    def get_file_contents
      lines = []
      lines << "Host git-codecommit.*.amazonaws.com"
      lines << "  User #{access_key_id}"
      lines << "  IdentityFile ~/.ssh/codecommit"
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
