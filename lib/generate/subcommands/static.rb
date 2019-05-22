require 'yaml'
require 'json'

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

    attr_reader :settings, :required_options, :optional_options

    def initialize ( argv )
      super(argv)
      domainName = 'domainName'
      serviceName = 'serviceName'
      environments = 'environments'
      productionName = 'productionName'
      @required_options = [
        '-D', domainName,
        '-S', serviceName
      ]
      @optional_options = [
        '-E', 'environmentName',
        '-P', productionName
      ]

      if argv.include?('-h')
        puts
        puts ([script_name,'static']+required_options+optional_options).join(' ')
        puts
        exit
      end

      @settings = Hash.new
      settings[environments] = []

      key = "unknown"
      argv.each do |arg|
        if (arg == 'static')
          # skip
        elsif (arg == '-D')
          key = domainName
        elsif (arg == '-S')
          key = serviceName
        elsif (arg == '-E')
          key = environments
        elsif (arg == '-P')
          key = productionName
        else
          raise "UNKNOWN ARGUMENTS: #{arg}" if key == 'unknown'
          settings[key] = settings[key].kind_of?(Array) ? settings[key].push(arg) : arg
          key = "unknown"
        end
      end
      if settings[productionName] and not settings[environments].include? settings[productionName]
        settings[environments] << settings[productionName]
      end

      unless settings[domainName] and settings[serviceName]
        puts
        puts ([script_name,'static']+required_options+optional_options).join(' ')
        puts
        exit
      end
    end

    def valid?
      true
    end

    def help
      "#{script_name} script"
    end

    def execute
      yaml_file_name = 'serverless.yml'
      json_file_name = 'serverless.json'

      if File.exist? yaml_file_name
        puts "Reading #{yaml_file_name}"
        yaml_hash = YAML.load_file(yaml_file_name)
      else
        yaml_hash = Hash.new
      end

      json_hash = {
        domainName: settings['domainName'],
        serviceName: settings['serviceName'],
        cfHostedZoneId: 'Z2FDTNDATAQYW2' # specified by AWS docs for RecordSet alias of CloudFront
      }

      prefix = 'StaticContent'

      settings['environments'].each do |environment|
        oai = ::Generate::Oai.new(environment, prefix, settings)
        bucket = ::Generate::Bucket.new(environment, prefix, settings)
        bucket_policy = ::Generate::BucketPolicy.new(environment, prefix, settings, bucket, oai)
        certificate = ::Generate::Certificate.new(environment, prefix, settings)
        distribution = ::Generate::Distribution.new(environment, prefix, settings, bucket, oai, certificate)
        record_set = ::Generate::RecordSet.new(environment, prefix, settings, distribution)

        items = [oai, bucket, bucket_policy, certificate, distribution, record_set]

        yaml_hash = Service.new.apply(yaml_hash, settings)
        yaml_hash = Provider.new.apply(yaml_hash)
        yaml_hash = Custom.new.apply(yaml_hash, settings)
        yaml_hash = Resources.new.apply(yaml_hash, items)
      end

      puts "Writing #{yaml_file_name}"
      File.write(yaml_file_name, yaml_hash.to_yaml)

      puts "Writing #{json_file_name}"
      File.write(json_file_name, JSON.pretty_generate(json_hash))
    end

  end # class

end # module
