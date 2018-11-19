require_relative './base'

module CodeCommit

  class Clone < CodeCommit::Base

    def valid?
      argv.size == 1
    end

    def help
      "#{script_name} clone"
    end

    def execute
      action = argv.shift

      begin
        answers = prepare_to_connect_to_origin(false)
        aws  = answers['AWS']
        ssh  = answers['SSH']

        log

        projects = aws['PROJECTS']
        repository = aws['REPOSITORY']
        region = aws['REGION']
        Dir.chdir(projects) do
          run_command "git clone ssh://git-codecommit.#{region}.amazonaws.com/v1/repos/#{repository}"
        end

        done_message
      rescue => e
        error_message(e)
      end

    end

  end # class

end # module
