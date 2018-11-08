require_relative './base'
require_relative './commander'
require_relative './loader'

module CodeCommit

  class Help < CodeCommit::Base

    COMMANDS = CodeCommit::Commander::COMMANDS
    DEFAULT  = CodeCommit::Commander::DEFAULT

    def valid?
      true
    end

    def help
      "#{script_name} help"
    end

    def execute
      puts
      loader = CodeCommit::Loader.new(COMMANDS,DEFAULT)
      loader.create_all(argv).each do |cmd|
        puts cmd.help
      end
      puts
    end
  end

end
