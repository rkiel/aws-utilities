require_relative './base'
require_relative './commander'
require_relative './loader'

module SwitchUser

  class Tab < SwitchUser::Base

    COMMANDS = SwitchUser::Commander::COMMANDS
    DEFAULT  = SwitchUser::Commander::DEFAULT

    def valid?
      true
    end

    def help
      "#{script_name} tab [pattern]"
    end

    def execute
      account_user_actions = ['config','remove','use']
      account_actions = ['add']

      if argv.size == 1
        pattern = '.+'
        loader = SwitchUser::Loader.new(COMMANDS,DEFAULT)
        puts loader.search(pattern).join("\n")
      elsif argv.size == 2 # awssu tab awssu
        pattern = '.+'
        loader = SwitchUser::Loader.new(COMMANDS,DEFAULT)
        puts loader.search(pattern).join("\n")
      elsif argv.size == 3 # awssu tab awssu pattern
        pattern = argv[2]
        if account_user_actions.include?(pattern) or account_actions.include?(pattern)
          puts list_directory(awssu_root_dir).join("\n")
        elsif COMMANDS.map { |x| x.to_s }.include? pattern
          puts
        else
          loader = SwitchUser::Loader.new(COMMANDS,DEFAULT)
          puts loader.search("^#{pattern}").join("\n")
        end
      elsif argv.size == 4 # awssu tab awssu ADD|USE pattern
        action = argv[2]
        if account_user_actions.include?(action) or account_actions.include?(action)
          pattern = argv[3]
          dirs = list_directory(awssu_root_dir)
          if dirs.include? pattern
            if account_user_actions.include?(action)
              puts list_directory(awssu_root_dir,pattern).join("\n")
            else
              puts
            end
          else
            puts dirs.select {|x| x.start_with?(pattern) }.join("\n")
          end
        else
          puts
        end
      elsif argv.size == 5 # awssu tab awssu USE account pattern
        action = argv[2]
        if account_user_actions.include?(action)
          account = argv[3]
          pattern = argv[4]
          dirs = list_directory(awssu_root_dir,account)
          if dirs.include? pattern
            puts
          else
            puts dirs.select {|x| x.start_with?(pattern) }.join("\n")
          end
        else
          puts
        end
      else
        puts
      end
    end
  end

end
