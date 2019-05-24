require_relative './resource'

module Generate

  class Bucket < ::Generate::Resource

    def initialize(environment, name, suffix = 'Bucket')
      super(environment, name, suffix)
    end

    def key
      name
    end

    def generate
      data = Hash.new
      data[name] = {
        'Type' => 'AWS::S3::Bucket',
        'Properties' => {
          'BucketName' => "${self:custom.#{environment}.bucket_name}"
        }
      }

      data
    end

    def domain_name
      fn_get_attr(name, 'DomainName')
    end

    def origin_id
      fn_join("-", 'S3', ref)
    end
  end # class

end # module
