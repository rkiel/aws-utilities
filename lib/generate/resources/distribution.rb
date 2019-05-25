require_relative './resource'

module Generate

  class Distribution < ::Generate::Resource
    attr_reader :bucket, :oai, :certificate

    def initialize(environment, name, bucket, oai, certificate, suffix = 'Distribution')
      super(environment, name, suffix)
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
            # Unfortunately S3 website hosting wasn’t playing nice with ReactRouter
            # http://aserafin.pl/2016/03/23/react-router-on-amazon-s3/
            'CustomErrorResponses' => [
              {
                'ErrorCode' => 403,
                'ResponseCode' => 200,
                'ResponsePagePath' => '/index.html'
              },
              {
                'ErrorCode' => 404,
                'ResponseCode' => 200,
                'ResponsePagePath' => '/index.html'
              }
            ],
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
              "${self:custom.#{environment}.domain_name}"
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
