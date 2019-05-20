require_relative './resource'

module Generate

  class Distribution < ::Generate::Resource
    attr_reader :name, :bucket, :oai

    def initialize(name, bucket, oai)
      @name = name
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
               'DomainName' => fn_get_attr(bucket.name+'.DomainName'),
                'Id' => fn_join("-", 'S3', fn_ref(bucket.name)),
                'S3OriginConfig' => {
                  'OriginAccessIdentity' => fn_join("/",'origin-access-identity', 'cloudfront', fn_ref(oai.name))
                }
              }
            ],
            'Enabled' => true,
            'DefaultCacheBehavior' => {
              'Compress' =>  true,
              'ForwardedValues' => {
                'QueryString' => false
              },
              'TargetOriginId' => fn_join("-", 'S3', fn_ref(bucket.name)),
              'ViewerProtocolPolicy' => 'redirect-to-https'
            },
            'Comment' => fn_ref(bucket.name)
          }
        }
      }

      data
    end
  end # class

end # module
