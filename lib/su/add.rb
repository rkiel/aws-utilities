require_relative './base'

module SwitchUser

  class Add < SwitchUser::Base

    def valid?
      argv.size == 6
    end

    def help
      "#{script_name} add account user pathToCsvFile region format"
    end

    def execute
      action = argv.shift
      account = argv.shift
      user = argv.shift
      path_to_csv_file = argv.shift
      region = argv.shift
      format = argv.shift

      begin
        base_dir = File.join(awssu_root_dir)
        mkdir(base_dir)
        base_dir = File.join(awssu_root_dir,account)
        mkdir(base_dir)
        base_dir = File.join(awssu_root_dir,account,user)
        mkdir(base_dir)

        file_must_exist path_to_csv_file
        arr_of_arrs = CSV.read(path_to_csv_file)
        access_key_id_position = nil
        access_key_id = nil
        secret_access_key_position = nil
        secret_access_key = nil
        arr_of_arrs.each_with_index do |row, row_index|
          if row_index == 0
            row.each_with_index do |column, column_index|
              if column.to_s.downcase ==  "Access key ID".downcase
                access_key_id_position = column_index
              elsif column.to_s.downcase == "Secret access key".downcase
                secret_access_key_position = column_index
              end
            end
          else
            access_key_id = row[access_key_id_position]
            secret_access_key = row[secret_access_key_position]
          end
        end

        file_name = File.join(base_dir, 'credentials')
        file_not_must_exist file_name
        log "Adding #{file_name}"
        File.open(file_name, "w") do |f|
          f.puts ";"
          f.puts "; #{account} #{user}"
          f.puts ";"
          f.puts "[default]"
          f.puts "aws_access_key_id = #{access_key_id}"
          f.puts "aws_secret_access_key = #{secret_access_key}"
        end
        lock_down file_name

        file_name = File.join(base_dir, 'config')
        file_not_must_exist file_name
        log "Adding #{file_name}"
        File.open(file_name, "w") do |f|
          f.puts ";"
          f.puts "; #{account} #{user}"
          f.puts ";"
          f.puts "[default]"
          f.puts "region = #{region}"
          f.puts "output = #{format}"
        end
        lock_down file_name
      rescue => e
        log e.message
      end
    end
  end

end
