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
          'Bucket' => fn_ref(bucket.name),
          'PolicyDocument' => {
            'Statement' => [
              {
                'Action' => [ 's3:GetObject' ],
                'Effect' => 'Allow',
                'Resource' => fn_join("/", fn_get_attr(bucket.name+'.Arn'), "*"),
                'Principal' => {
                  'CanonicalUser' => fn_get_attr(oai.name+'.S3CanonicalUserId')
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
