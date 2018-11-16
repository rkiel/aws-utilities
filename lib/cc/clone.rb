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

        region = aws['REGION']
        full_ssh_file_path = ssh_file_path(ssh['FILE_NAME'])
        raise "SSH key #{full_ssh_file_path} does not exist" unless File.exist? full_ssh_file_path

        identities = capture_command("ssh-add -l", false).split("\n")
        been_added = identities.reduce(false) { |accum,elem| accum ? accum : elem.include?(full_ssh_file_path) }
        if been_added
          log "SSH key #{full_ssh_file_path} already added to ssh-agent"
        else
          run_command "ssh-add #{full_ssh_file_path}"
        end

        log

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
