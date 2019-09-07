module SwitchUser
  class ConfigFile
    attr_reader :account, :user, :json_hash

    def initialize(account, user)
      @account = account
      @user = user
      load
    end

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

    def load
      if File.exist? file_name
        @json_hash = JSON.parse(File.read(file_name))
      else
        set_account account
        set_user  user
        set_pki false
        set_codecommit false
      end
    end

    def save
      log "Saving #{file_name}"
      File.write(file_name, JSON.pretty_generate(json_hash))
      lock_down file_name
    end

    def must_not_exist
      raise "ERROR: #{file_name} already exists" if File.exist? file_name
    end

    def must_exist
      raise "ERROR: #{file_name} does not exists" unless File.exist? file_name
    end

    private

    def log (msg)
      puts msg.gsub(Regexp.new(ENV['HOME']), '~')
    end

    def awssu_root_dir
#      File.join(aws_root_dir,'awssu')
      @awssu_root_dir ||= File.join(ENV['HOME'], '.awssu')
    end

    def file_name
      @file_name ||= begin
      #name = [account,user, 'awssu'].join('_')
        name = 'configure'
        name = [name,'json'].join('.')
        File.join(awssu_root_dir, account, user, name)
      end
    end

    def lock_down (file_name)
      File.chmod(0600,file_name)
    end
  end
end
