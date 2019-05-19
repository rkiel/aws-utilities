require_relative './base'
require_relative './commander'
require_relative './loader'

module Generate

  class Tab < ::Generate::Base

    COMMANDS = ::Generate::Commander::COMMANDS
    DEFAULT  = ::Generate::Commander::DEFAULT

    def valid?
      true
    end

    def help
      "#{script_name} tab [pattern]"
    end

    def execute
      if argv.size == 1
        pattern = '.+'
        loader = ::Generate::Loader.new(COMMANDS,DEFAULT)
        puts loader.search(pattern).join("\n")
      elsif argv.size == 2 # codecommit tab codecommit
        loader = ::Generate::Loader.new(COMMANDS,DEFAULT)
        puts loader.search(".+").join("\n")
      elsif argv.size == 3 # codecommit tab codecommit pattern
        pattern = argv[2]
        if COMMANDS.map { |x| x.to_s }.include? pattern
          puts
        else
          loader = ::Generate::Loader.new(COMMANDS,DEFAULT)
          puts loader.search("^#{pattern}").join("\n")
        end
      else
        puts
      end
    end
  end

end
