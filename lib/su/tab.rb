require_relative './base'
require_relative './commander'
require_relative './loader'

module SwitchUser

  class Tab < SwitchUser::Base

    COMMANDS = SwitchUser::Commander::COMMANDS
    DEFAULT  = SwitchUser::Commander::DEFAULT

    def valid?
      [1,2].include? argv.size
    end

    def help
      "#{script_name} tab [pattern]"
    end

    def execute
      if argv.size == 1
        pattern = '.+'
      elsif argv.size == 2
        pattern = "^#{argv[1]}"
      end

      loader = SwitchUser::Loader.new(COMMANDS,DEFAULT)
      puts loader.search(pattern).join("\n")
    end
  end

end
