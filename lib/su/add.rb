require_relative './base'
require_relative './config_file'

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
        cf = ::SwitchUser::ConfigFile.new(account, user)
        cf.must_not_exist
        cf.set_access_key(access_key_id)
        cf.set_secret_access_key(secret_access_key)
        cf.set_region(region)
        cf.set_output(format)
        cf.save

        file_name = ssh_config_name(account, user)
        file_not_must_exist file_name
        log "Adding #{file_name}"
        write_ssh_config(file_name, access_key_id)

        log "Removing #{path_to_csv_file}"
        File.delete path_to_csv_file
        # log "SKIPPING **** Removing #{path_to_csv_file}"
        puts
      rescue => e
        log e.message
      end
    end
  end

end
