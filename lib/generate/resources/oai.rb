require_relative './resource'

module Generate

  class Oai < ::Generate::Resource

    def initialize(environment, name, suffix = 'Oai')
      super(environment, name, suffix)
    end

    def generate
      data = Hash.new
      data[name] = {
        'Type' => 'AWS::CloudFront::CloudFrontOriginAccessIdentity',
        'Properties' => {
          'CloudFrontOriginAccessIdentityConfig' => {
            'Comment' => "${self:custom.#{environment}.bucket_name}"
          }
        }
      }

      data
    end

    def cannonical_user_id
      fn_get_attr(name, 'S3CanonicalUserId')
    end

    def path_ref
      fn_join('/', 'origin-access-identity', 'cloudfront', ref)
    end
  end # class

end # module
