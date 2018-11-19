require_relative './base'

module CodeCommit

  class Add < CodeCommit::Base

    def valid?
      argv.size == 1
    end

    def help
      "#{script_name} add"
    end

    def execute
      action = argv.shift

      begin
        answers = prepare_to_connect_to_origin(true)
        aws  = answers['AWS']
        ssh  = answers['SSH']

        log

        projects = aws['PROJECTS']
        repository = aws['REPOSITORY']
        region = aws['REGION']
        Dir.chdir(File.join(projects,repository)) do
          run_command "git remote add origin ssh://git-codecommit.#{region}.amazonaws.com/v1/repos/#{repository}"
          run_command "git checkout master"
          run_command "git push -u origin master"
        end

        done_message
      rescue => e
        error_message(e)
      end

    end

  end # class

end # module
