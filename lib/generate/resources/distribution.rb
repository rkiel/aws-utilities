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
                'Id' => bucket.origin_id,
                'S3OriginConfig' => {
                  'OriginAccessIdentity' => oai.path_ref
                }
              }
            ],
            'Enabled' => true,
            'DefaultCacheBehavior' => {
              'AllowedMethods' => ['GET', 'HEAD'],
              'Compress' =>  true,
              'ForwardedValues' => {
                'QueryString' => false,
                'Cookies' => {
                  'Forward' => 'none'
                }
              },
              'TargetOriginId' => bucket.origin_id,
              'ViewerProtocolPolicy' => 'redirect-to-https'
            },
            'Comment' => bucket.ref,
            'HttpVersion' => 'http2',
            'DefaultRootObject' => 'index.html'
          }
        }
      }

      data
    end
  end # class

end # module
