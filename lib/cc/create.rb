require_relative './base'

module CodeCommit

  class Create < CodeCommit::Base

    def valid?
      argv.size == 1
    end

    def help
      "#{script_name} create"
    end

    def execute
      action = argv.shift

      begin
        log
        answers = get_answers
        prompt answers, "CodeCommit Repository Name", "AWS", "REPOSITORY"
        prompt answers, "Repository in AWS Region", "AWS", "REGION"
        save_answers answers

        aws = answers['AWS']

        repository = aws['REPOSITORY']
        region     = aws['REGION']

        run_command "aws codecommit create-repository --repository-name #{repository} --region #{region}"

        done_message
      rescue => e
        error_message(e)
      end
    end
  end

end
