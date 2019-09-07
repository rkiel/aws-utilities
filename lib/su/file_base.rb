module SwitchUser
  class FileBase
    attr_reader :account, :user

    def initialize(account, user)
      @account = account
      @user = user
      load
    end

    def load
      if File.exist? file_name
        log "Loading #{file_name}"
        contents = File.read(file_name)
      else
        contents = nil
      end
      set_file_contents contents
    end

    def save
      log "Saving #{file_name}"
      File.write(file_name, get_file_contents)
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

    def lock_down (file_name)
      # do nothging by default
    end

    def file_name
    end

    def get_file_contents
    end

    def set_file_contents (contents)
    end

  end
end
