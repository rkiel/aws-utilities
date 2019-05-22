require_relative './resource'

module Generate

  class Distribution < ::Generate::Resource
    attr_reader :bucket, :oai, :certificate

    def initialize(name, bucket, oai, certificate, suffix = 'Distribution')
      super(name, suffix)
      @bucket = bucket
      @oai = oai
      @certificate = certificate
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
            'DefaultRootObject' => 'index.html',
            'Aliases' => [
              '${self:provider.stage}.${self:custom.domainName}'
            ],
            'ViewerCertificate' => {
              'AcmCertificateArn' => certificate.ref,
              'SslSupportMethod' => 'sni-only'
            }
          }
        }
      }

      data
    end

    def domain_name
      fn_get_attr(name, 'DomainName')
    end

  end # class

end # module
