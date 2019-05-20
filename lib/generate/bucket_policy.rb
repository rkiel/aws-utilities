require_relative './resource'

module Generate

  class BucketPolicy < ::Generate::Resource
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
        'Type' => 'AWS::S3::BucketPolicy',
        'Properties' => {
          'Bucket' => bucket.ref,
          'PolicyDocument' => {
            'Statement' => [
              {
                'Action' => [ 's3:GetObject' ],
                'Effect' => 'Allow',
                'Resource' => fn_join("/", bucket.arn, "*"),
                'Principal' => {
                  'CanonicalUser' => oai.cannonical_user_id
                }
              }
            ]
          }
        }
      }

      data
    end
  end # class

end # module
