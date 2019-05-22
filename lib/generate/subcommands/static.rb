require 'yaml'

require_relative './base'

require_relative '../resources/oai'
require_relative '../resources/bucket'
require_relative '../resources/bucket_policy'
require_relative '../resources/distribution'
require_relative '../resources/record_set'
require_relative '../resources/certificate'

require_relative '../sections/service'
require_relative '../sections/provider'
require_relative '../sections/custom'
require_relative '../sections/resources'

module Generate

  class Static < ::Generate::Base

    attr_reader :settings

    def initialize ( argv )
      super(argv)
      domainName = 'domainName'
      hostedZoneId = 'hostedZoneId'
      serviceName = 'serviceName'
      raise "-D #{domainName} -H #{hostedZoneId} -S #{serviceName}" unless valid?

      @settings = Hash.new
      key = "unknown"
      argv.each do |arg|
        if (arg == 'static')
          # skip
        elsif (arg == '-D')
          key = domainName
        elsif (arg == '-H')
          key = hostedZoneId
        elsif (arg == '-S')
          key = serviceName
        else
          raise "UNKNOWN ARGUMENTS: #{arg}" if key == 'unknown'
          settings[key] = arg
          key = "unknown"
        end
      end
    end

    def valid?
      argv.size == 7
    end

    def help
      "#{script_name} script"
    end

    def execute
      file_name = 'serverless.yml'

      if File.exist? file_name
        puts "Reading #{file_name}"
        hash = YAML.load_file(file_name)
      else
        hash = Hash.new
      end

      prefix = 'StaticContent'

      oai = ::Generate::Oai.new(prefix)
      bucket = ::Generate::Bucket.new(prefix)
      bucket_policy = ::Generate::BucketPolicy.new(prefix, bucket, oai)
      certificate = ::Generate::Certificate.new(prefix, settings)
      distribution = ::Generate::Distribution.new(prefix, bucket, oai, certificate)
      record_set = ::Generate::RecordSet.new(prefix, settings, distribution)

      items = [oai, bucket, bucket_policy, certificate, distribution, record_set]

      hash = Service.new.apply(hash, settings)
      hash = Provider.new.apply(hash)
      hash = Custom.new.apply(hash, settings)
      hash = Resources.new.apply(hash, items)

      puts "Writing #{file_name}"
      File.write(file_name, hash.to_yaml)
    end

  end # class

end # module
