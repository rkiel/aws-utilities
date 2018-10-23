require_relative './base'

module SwitchUser

  class List < SwitchUser::Base


    def valid?
      argv.size == 1
    end

    def help
      "#{script_name} list"
    end

    def execute

      begin
        list
      rescue => e
        puts e.message
      end
    end
  end

end
