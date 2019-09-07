require_relative './file_base'

module SwitchUser
  class ConfigFile < ::SwitchUser::FileBase

    attr_accessor :awssu_account
    attr_accessor :awssu_user
    attr_accessor :awssu_pki
    attr_accessor :awssu_codecommit
    attr_accessor :aws_access_key_id
    attr_accessor :aws_secret_access_key
    attr_accessor :region
    attr_accessor :output

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
      json_hash = {
        awssu_account: awssu_account,
        awssu_user: awssu_user,
        awssu_pki: awssu_pki,
        awssu_codecommit: awssu_codecommit,
        aws_access_key_id: aws_access_key_id,
        aws_secret_access_key: aws_secret_access_key,
        region: region,
        output: output
      }
      JSON.pretty_generate(json_hash)
    end

    def set_file_contents (contents)
      if contents
        json_hash = JSON.parse(contents)
        @awssu_account = json_hash["awssu_account"]
        @awssu_user = json_hash["awssu_user"]
        @awssu_pki = json_hash["awssu_pki"]
        @awssu_codecommit = json_hash["awssu_codecommit"]
        @aws_access_key_id = json_hash["aws_access_key_id"]
        @aws_secret_access_key = json_hash["aws_secret_access_key"]
        @region = json_hash["region"]
        @output = json_hash["output"]
      else
        @awssu_account = account
        @awssu_user =  user
        @awssu_pki = false
        @awssu_codecommit = false
      end
    end

    def lock_down (file_name)
      File.chmod(0600,file_name)
    end
  end
end
