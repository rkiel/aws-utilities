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
        puts
        answers = get_answers
        aws  = answers['AWS']
        ssh  = answers['SSH']

        prompt answers, "Project directory",          "AWS", "PROJECTS"
        prompt answers, "CodeCommit Repository Name", "AWS", "REPOSITORY"

        projects = aws['PROJECTS']
        repository = aws['REPOSITORY']

        full_repository_file_path = File.join(projects, repository)
        raise "Repository #{full_repository_file_path} already exists" if File.exist? full_repository_file_path

        prompt answers, "Repository in AWS Region",   "AWS", "REGION"
        prompt answers, "SSH File Name",              "SSH", "FILE_NAME"
        save_answers answers

        ssh_add_to_agent(ssh['FILE_NAME'])

        log

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
