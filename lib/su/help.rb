require_relative './base'
require_relative './commander'
require_relative './loader'

module SwitchUser

  class Help < SwitchUser::Base

    COMMANDS = SwitchUser::Commander::COMMANDS
    DEFAULT  = SwitchUser::Commander::DEFAULT

    def valid?
      true
    end

    def help
      "#{script_name} help"
    end

    def execute
      puts
      loader = SwitchUser::Loader.new(COMMANDS,DEFAULT)
      loader.create_all(argv).each do |cmd|
        puts cmd.help
      end
      puts
    end
  end

end
