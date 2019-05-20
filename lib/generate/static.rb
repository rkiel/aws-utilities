require 'yaml'

require_relative './base'
require_relative './oai'
require_relative './bucket'
require_relative './bucket_policy'
require_relative './distribution'

module Generate

  class Static < ::Generate::Base

    def valid?
      argv.size == 1
    end

    def help
      "#{script_name} script"
    end

    def execute
      answers_path = 'serverless.yml'

      if File.exist? answers_path
        puts "Reading #{answers_path}"
        data = YAML.load_file(answers_path)
      else
        puts "Creating #{answers_path}"

        data = { }

        setPath(data, 'service', 'TBD')
        setPath(data, 'provider.name', 'aws')
        setPath(data, 'provider.runtime', 'nodejs10')

      #  File.write(answers_path, data.to_yaml)
      end

      prefix = 'StaticContent'

      oai = ::Generate::Oai.new(prefix)
      bucket = ::Generate::Bucket.new(prefix)
      bucket_policy = ::Generate::BucketPolicy.new(prefix, bucket, oai)
      distribution = ::Generate::Distribution.new(prefix, bucket, oai)

      items = [oai, bucket, bucket_policy, distribution]


      data['resources'] = Hash.new unless data['resources']
      resources = data['resources']
      resources['Resources'] = Hash.new unless resources['Resources']

      items.each do |item|
        resources['Resources'] = resources['Resources'].merge(item.generate)
      end

      puts data
      File.write(answers_path, data.to_yaml)
    end

    private

    def something (object, paths, value)
      if paths.empty?
        return value
      else
        key = paths.shift
        object[key] = object[key] == nil ? Hash.new : object[key]
        object[key] = something(object[key], paths, value)
        object
      end
    end

    def setPath(object, path, value)
      parts = path.split('.')
      something(object, parts, value)
    end

  end # class

end # module
