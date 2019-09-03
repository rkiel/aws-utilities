require_relative './base'

module SwitchUser

  class Add < SwitchUser::Base

    def valid?
      argv.size > 5
    end

    def help
      "#{script_name} add account user pathToCsvFile region format [passphrase [comment]]"
    end

    def execute
      action = argv.shift
      account = argv.shift
      user = argv.shift
      path_to_csv_file = argv.shift
      region = argv.shift
      format = argv.shift
      passphrase = argv.shift
      comment = argv.shift

      begin
        base_dir = create_path account, user

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

        puts
        file_name = json_name(account, user)
        file_not_must_exist file_name
        log "Adding #{file_name}"
        json_hash = create_json account, user, access_key_id, secret_access_key, region, format
        write_json file_name, json_hash

        log "Removing #{path_to_csv_file}"
        File.delete path_to_csv_file
        puts
      rescue => e
        log e.message
      end
    end
  end

end
