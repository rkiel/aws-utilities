require_relative './resource'

module Generate

  class Distribution < ::Generate::Resource
    attr_reader :bucket, :oai

    def initialize(name, bucket, oai, suffix = 'Distribution')
      super(name, suffix)
      @bucket = bucket
      @oai = oai
    end

    def key
      name
    end

    def generate
      data = Hash.new
      data[name] = {
        'Type' => 'AWS::CloudFront::Distribution',
        'Properties' => {
          'DistributionConfig' => {
            'Origins' => [
              {
               'DomainName' => bucket.domain_name,
                'Id' => fn_join("-", 'S3', bucket.ref),
                'S3OriginConfig' => {
                  'OriginAccessIdentity' => fn_join("/",'origin-access-identity', 'cloudfront', oai.ref)
                }
              }
            ],
            'Enabled' => true,
            'DefaultCacheBehavior' => {
              'Compress' =>  true,
              'ForwardedValues' => {
                'QueryString' => false
              },
              'TargetOriginId' => fn_join("-", 'S3', bucket.ref),
              'ViewerProtocolPolicy' => 'redirect-to-https'
            },
            'Comment' => bucket.ref
          }
        }
      }

      data
    end
  end # class

end # module
