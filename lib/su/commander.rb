require_relative './loader'

module SwitchUser

  class Commander

    COMMANDS = [
      :add,
      :config,
      :export,
      :help,
      :list,
      :pick,
      :pki,
      :remove,
      :safe,
      :show,
      :tab,
      :use
    ].sort

    DEFAULT = :help

    attr_reader :subcommand

    def initialize (argv)
      key = (argv[0] ? argv[0].to_sym : DEFAULT)
      @subcommand = ::SwitchUser::Loader.new(COMMANDS,DEFAULT).create(key,argv)
    end

    def valid?
      subcommand.valid?
    end

    def usage
      subcommand.usage
    end

    def execute
      puts
      subcommand.execute
      puts
    end

  end

end
