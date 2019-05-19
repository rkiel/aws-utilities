require_relative './base'
require_relative './commander'
require_relative './loader'

module Generate

  class Help < ::Generate::Base

    COMMANDS = ::Generate::Commander::COMMANDS
    DEFAULT  = ::Generate::Commander::DEFAULT

    def valid?
      true
    end

    def help
      "#{script_name} help"
    end

    def execute
      puts
      loader = ::Generate::Loader.new(COMMANDS,DEFAULT)
      loader.create_all(argv).each do |cmd|
        puts cmd.help
      end
      puts
    end
  end

end
