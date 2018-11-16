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
        prompt answers, "CodeCommit Repository Name", "AWS", "REPOSITORY"
        prompt answers, "Repository in AWS Region",   "AWS", "REGION"
        prompt answers, "Project directory",          "AWS", "PROJECTS"
        prompt answers, "SSH File Name",              "SSH", "FILE_NAME"
        save_answers answers

        aws  = answers['AWS']
        ssh  = answers['SSH']

        repository = aws['REPOSITORY']
        region = aws['REGION']
        projects = aws['PROJECTS']
        sshfile = ssh_file_path(ssh['FILE_NAME'])

        identities = capture_command("ssh-add -l", false).split("\n")
        file_name = File.join(projects, repository)
        been_added = identities.reduce(false) { |accum,elem| accum ? accum : elem.include?(sshfile) }
        if been_added
          log "#{sshfile} already added to ssh-agent"
        else
          run_command "ssh-add #{sshfile}"
        end
        log

        Dir.chdir(projects) do
          if File.exist? file_name
            raise "#{file_name} already exists"
          else
            run_command "git clone ssh://git-codecommit.#{region}.amazonaws.com/v1/repos/#{repository}"
          end
        end

        log
        log "DONE"
        log
      rescue => e
        error_message(e)
      end

    end

  end # class

end # module
