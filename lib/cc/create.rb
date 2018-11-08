
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
        puts
        answers = get_answers
        prompt answers, "CodeCommit Repository Name", "AWSREPO"
        prompt answers, "Repository in AWS Region", "AWSREGION"
        save_answers answers

        aws_repo = answers['AWSREPO']
        aws_region = answers['AWSREGION']
        run_command "aws codecommit create-repository --repository-name #{aws_repo} --region #{aws_region}"
        puts
        puts "DONE"
        puts
      rescue => e
        puts e.message
      end
    end
  end

end
