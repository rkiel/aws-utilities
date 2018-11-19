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
        puts
        answers = get_answers
        aws  = answers['AWS']
        ssh  = answers['SSH']

        prompt answers, "Project directory",          "AWS", "PROJECTS"
        prompt answers, "CodeCommit Repository Name", "AWS", "REPOSITORY"

        projects = aws['PROJECTS']
        repository = aws['REPOSITORY']

        full_repository_file_path = File.join(projects, repository)
        raise "Repository #{full_repository_file_path} does not exists" unless File.exist? full_repository_file_path

        prompt answers, "Repository in AWS Region",   "AWS", "REGION"
        prompt answers, "SSH File Name",              "SSH", "FILE_NAME"
        save_answers answers

        ssh_add_to_agent(ssh['FILE_NAME'])

        log

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
