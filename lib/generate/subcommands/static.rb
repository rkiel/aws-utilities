require 'yaml'

require_relative './base'
require_relative '../resources/oai'
require_relative '../resources/bucket'
require_relative '../resources/bucket_policy'
require_relative '../resources/distribution'
require_relative '../sections/service'
require_relative '../sections/provider'
require_relative '../sections/custom'
require_relative '../sections/resources'

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
        data = Hash.new
      end

      prefix = 'StaticContent'

      oai = ::Generate::Oai.new(prefix)
      bucket = ::Generate::Bucket.new(prefix)
      bucket_policy = ::Generate::BucketPolicy.new(prefix, bucket, oai)
      distribution = ::Generate::Distribution.new(prefix, bucket, oai)

      items = [oai, bucket, bucket_policy, distribution]

      data = Service.new.apply(data)
      data = Provider.new.apply(data)
      data = Custom.new.apply(data)
      data = Resources.new.apply(data, items)

      puts "Writing #{answers_path}"
      File.write(answers_path, data.to_yaml)
    end

  end # class

end # module
