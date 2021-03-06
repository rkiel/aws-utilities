require_relative './loader'

module CodeCommit

  class Commander

    COMMANDS = [
      :add,
      :clone,
      :config,
      :create,
      :generate,
      :help,
      :tab
    ].sort

    DEFAULT = :help

    attr_reader :subcommand

    def initialize (argv)
      key = (argv[0] ? argv[0].to_sym : DEFAULT)
      @subcommand = ::CodeCommit::Loader.new(COMMANDS,DEFAULT).create(key,argv)
    end

    def valid?
      subcommand.valid?
    end

    def usage
      subcommand.usage
    end

    def execute
      subcommand.execute
    end

  end

end
