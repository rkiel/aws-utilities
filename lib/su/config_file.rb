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

    def export(profile)
      set_file_contents nil
      aws_configure_keys.each do |key|
        cmd = "aws configure get #{key} --profile #{profile}"
        puts cmd
        send("#{key}=", `#{cmd}`.strip)
      end
    end

    def show
      set_file_contents nil
      profile = 'default'
      json_hash = {}
      all_configure_keys.each do |key|
        cmd = "aws configure get #{key} --profile #{profile}"
        puts cmd
        json_hash[key] = `#{cmd}`.strip
      end
      puts JSON.pretty_generate(json_hash)
    end

    def switch(safe_mode = true)
      all_configure_keys.each do |key|
        default_value = "SAFE_#{key.upcase}"
        value = safe_mode ? default_value : send("#{key}")
        cmd = "aws configure set #{key} #{value}"
        puts cmd
        system cmd
      end
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
      json_hash = {}
      all_configure_keys.each do |key|
        json_hash[key] = send("#{key}")
      end
      JSON.pretty_generate(json_hash)
    end

    def set_file_contents (contents)
      if contents
        json_hash = JSON.parse(contents)
      else
        json_hash = {
          "awssu_account" =>  account,
          "awssu_user" => user,
          "awssu_pki" => false,
          "awssu_codecommit" => false
        }
      end
      all_configure_keys.each do |key|
        send("#{key}=", json_hash[key])
      end
    end

    def aws_configure_keys
      ["aws_access_key_id", "aws_secret_access_key", "region", "output"]
    end

    def awssu_configure_keys
      ["awssu_account","awssu_user","awssu_pki","awssu_codecommit"]
    end

    def all_configure_keys
      awssu_configure_keys + aws_configure_keys
    end

    def lock_down (file_name)
      File.chmod(0600,file_name)
    end
  end
end
