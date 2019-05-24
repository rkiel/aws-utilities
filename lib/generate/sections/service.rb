module Generate

  class Service

    def apply (data, json_hash)
      data['service'] ||= Hash.new

      if data['service'].is_a? String
        data['service'] = {
          'name' => data['service']
        }
      end

      defaults = {
        'name' => json_hash['serviceName']
      }

      data['service'] = defaults.merge(data['service'])

      data
    end

  end # class

end # module
