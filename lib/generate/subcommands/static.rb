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

    DEFAULT_PREFIX = 'StaticContent'
    DEFAULT_CF_ZONE_ID = 'Z2FDTNDATAQYW2' # specified by AWS docs for RecordSet alias of CloudFront
    DEFAULT_ENVIRONMENTS = []
    DEFAULT_VALUE = ''

    def valid?
      argv.size == 1
    end

    def help
      "#{script_name} script"
    end

    def execute
      yaml_file_name = 'serverless.yml'
      json_file_name = 'serverless.json'

      required_fields = ['domainName','serviceName']
      optional_fields = ['prefix', 'cfHostedZoneId', 'environments', 'productionName']

      puts
      if File.exist? json_file_name
        puts "Reading #{json_file_name}"
        json_hash = JSON.parse(File.read(json_file_name))
      else
        puts "WARNING: missing #{json_file_name}"
        puts "Creating empty #{json_file_name}"
        json_hash = {}
        (required_fields+optional_fields).each { |x| json_hash[x] = DEFAULT_VALUE}
        # set some defaults
        json_hash['prefix'] = DEFAULT_PREFIX
        json_hash['cfHostedZoneId'] = DEFAULT_CF_ZONE_ID
        json_hash['environments'] = DEFAULT_ENVIRONMENTS
        File.write(json_file_name, JSON.pretty_generate(json_hash))
      end

      required_fields.each do |field|
        unless has_value?(json_hash, field)
          puts
          puts "ERROR: missing #{field}"
          exit
        end
      end
      optional_fields.each do |field|
        unless has_value?(json_hash, field)
          puts
          puts "WARNING: missing #{field}"
        end
      end
      json_hash['prefix'] = get_value(json_hash, 'prefix', DEFAULT_PREFIX)
      json_hash['cfHostedZoneId'] = get_value(json_hash, 'cfHostedZoneId', DEFAULT_CF_ZONE_ID) # specified by AWS docs for RecordSet alias of CloudFront
      json_hash['environments'] = get_value(json_hash, 'environments', DEFAULT_ENVIRONMENTS)
      json_hash['productionName'] = get_value(json_hash, 'productionName', DEFAULT_VALUE)

      json_hash['environments'].push(json_hash['productionName'])
      json_hash['environments'] = json_hash['environments'].compact.map {|x| x.strip.downcase}.reject {|x| x == ''}.sort.uniq

      puts
      puts JSON.pretty_generate(json_hash)
      puts "Writing #{json_file_name}"
      File.write(json_file_name, JSON.pretty_generate(json_hash))

      puts
      if File.exist? yaml_file_name
        puts "Reading #{yaml_file_name}"
        yaml_hash = YAML.load_file(yaml_file_name)
      else
        yaml_hash = Hash.new
      end

      prefix = json_hash['prefix']
      json_hash['environments'].each do |environment|
        oai = ::Generate::Oai.new(environment, prefix)
        bucket = ::Generate::Bucket.new(environment, prefix)
        bucket_policy = ::Generate::BucketPolicy.new(environment, prefix, bucket, oai)
        certificate = ::Generate::Certificate.new(environment, prefix)
        distribution = ::Generate::Distribution.new(environment, prefix, bucket, oai, certificate)
        record_set = ::Generate::RecordSet.new(environment, prefix, distribution)

        items = [oai, bucket, bucket_policy, certificate, distribution, record_set]

        yaml_hash = Service.new.apply(yaml_hash, json_hash)
        yaml_hash = Provider.new.apply(yaml_hash)
        yaml_hash = Custom.new.apply(yaml_hash, json_hash)
        yaml_hash = Resources.new.apply(yaml_hash, items)
      end

      puts "Writing #{yaml_file_name}"
      File.write(yaml_file_name, yaml_hash.to_yaml)
    end

  private

    def get_value (hash, field, defaultValue)
      has_value?(hash, field) ? hash[field] : defaultValue
    end

    def has_value? (hash, field)
      hash[field] and hash[field].size > 0
    end

  end # class

end # module
