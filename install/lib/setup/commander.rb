module Setup

  class Commander

    attr_accessor :argv

    def initialize (argv)
      @argv = argv
    end

    def valid?
      true
    end

    def help
      exit
    end

    def execute
      File.open("#{ENV['HOME']}/.bash_profile", "a") do |f|
        f.puts
        f.puts "# added by ~/GitHub/rkiel/aws-utilities/install/bin/setup"
        f.puts 'export AWS_UTILITIES_BIN="~/GitHub/rkiel/aws-utilities/bin"'
        f.puts 'export PATH=${AWS_UTILITIES_BIN}:$PATH'
        f.puts
      end


      File.open("#{ENV['HOME']}/.bashrc", "a") do |f|
        f.puts
        f.puts "# added by ~/GitHub/rkiel/aws-utilities/install/bin/setup"
        f.puts 'source ~/GitHub/rkiel/aws-utilities/dotfiles/bashrc'
        f.puts
      end

    end

    private

    def run_cmd ( cmd )
      puts
      puts cmd
      success = system cmd
      unless success
        error "(see above)"
      end
      puts
    end

    def error ( msg )
      puts
      puts "ERROR: #{msg}"
      puts
      exit
    end

  end

end
