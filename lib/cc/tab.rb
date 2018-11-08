require_relative './base'
require_relative './commander'
require_relative './loader'

module CodeCommit

  class Tab < CodeCommit::Base

    COMMANDS = CodeCommit::Commander::COMMANDS
    DEFAULT  = CodeCommit::Commander::DEFAULT

    def valid?
      true
    end

    def help
      "#{script_name} tab [pattern]"
    end

    def execute
      if argv.size == 1
        pattern = '.+'
        loader = CodeCommit::Loader.new(COMMANDS,DEFAULT)
        puts loader.search(pattern).join("\n")
      elsif argv.size == 2 # codecommit tab codecommit
        loader = CodeCommit::Loader.new(COMMANDS,DEFAULT)
        puts loader.search(".+").join("\n")
      elsif argv.size == 3 # codecommit tab codecommit pattern
        pattern = argv[2]
        if COMMANDS.map { |x| x.to_s }.include? pattern
          puts
        else
          loader = CodeCommit::Loader.new(COMMANDS,DEFAULT)
          puts loader.search("^#{pattern}").join("\n")
        end
      else
        puts
      end
    end
  end

end
