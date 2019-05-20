require_relative './base'

module Generate

  class Static < ::Generate::Base

    def valid?
      argv.size == 1
    end

    def help
      "#{script_name} script"
    end

    def execute

    end

  end # class

end # module
