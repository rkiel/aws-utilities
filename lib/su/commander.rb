require_relative './loader'

module SwitchUser

  class Commander

    COMMANDS = [
      :add,
      :config,
      :help,
      :legacy,
      :list,
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
      @subcommand = SwitchUser::Loader.new(COMMANDS,DEFAULT).create(key,argv)
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
