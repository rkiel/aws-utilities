module SwitchUser
  class CsvFile
    attr_reader :file_name, :access_key_id, :secret_access_key

    def initialize(file_name)
      @file_name = file_name
    end

    def must_exist
      raise "ERROR: #{file_name} does not exists" unless File.exist? file_name
    end

    def load
      CSV.read(file_name)
    end

    def parse
      access_key_id_position = nil
      @access_key_id = nil
      secret_access_key_position = nil
      @secret_access_key = nil
      load.each_with_index do |row, row_index|
        if row_index == 0
          row.each_with_index do |column, column_index|
            if column.to_s.downcase ==  "Access key ID".downcase
              access_key_id_position = column_index
            elsif column.to_s.downcase == "Secret access key".downcase
              secret_access_key_position = column_index
            end
          end
        else
          @access_key_id = row[access_key_id_position]
          @secret_access_key = row[secret_access_key_position]
        end
      end
    end

    def remove
      # log "Removing #{file_name}"
      # File.delete file_name
      log "SKIPPING **** Removing #{file_name}"
    end

    private

    def log (msg)
      puts msg.gsub(Regexp.new(ENV['HOME']), '~')
    end

  end
end
