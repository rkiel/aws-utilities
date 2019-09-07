require_relative './file_base'

module SwitchUser
  class ConfigFile < ::SwitchUser::FileBase

    attr_reader :json_hash

    def set_access_key(access_key_id)
      json_hash["aws_access_key_id"] = access_key_id
    end

    def set_secret_access_key(secret_access_key)
      json_hash["aws_secret_access_key"] = secret_access_key
    end

    def set_region(region)
      json_hash["region"] = region
    end

    def set_output(output)
      json_hash["output"] = output
    end

    def set_account(account)
      json_hash["awssu_account"] = account
    end
    def set_user(user)
      json_hash["awssu_user"] = user
    end
    def set_pki(boolean)
      json_hash["awssu_pki"] = boolean
    end
    def set_codecommit(boolean)
      json_hash["awssu_codecommit"] = boolean
    end

    private

    def file_name
      @file_name ||= begin
      #name = [account,user, 'awssu'].join('_')
        name = 'configure'
        name = [name,'json'].join('.')
        File.join(awssu_root_dir, account, user, name)
      end
    end

    def get_file_contents
      JSON.pretty_generate(json_hash)
    end

    def set_file_contents (contents)
      if contents
        @json_hash = JSON.parse(contents)
      else
        @json_hash = {}
        set_account account
        set_user  user
        set_pki false
        set_codecommit false
      end
    end

    def lock_down (file_name)
      File.chmod(0600,file_name)
    end
  end
end
