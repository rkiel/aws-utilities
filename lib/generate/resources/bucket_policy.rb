require_relative './resource'

module Generate

  class BucketPolicy < ::Generate::Resource
    attr_reader :bucket, :oai

    def initialize(environment, name, settings, bucket, oai, suffix = 'BucketPolicy')
      super(environment, name, suffix, settings)
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
                "Sid" => "AllowGetByOai",
                'Action' => [ 's3:GetObject' ],
                'Effect' => 'Allow',
                'Resource' => fn_join("/", bucket.arn, "*"),
                'Principal' => {
                  'CanonicalUser' => oai.cannonical_user_id
                }
              },{
                "Sid" => "DenyIncorrectEncryptionHeader",
                "Action" => ["s3:PutObject"],
                "Effect" => "Deny",
                'Resource' => fn_join("/", bucket.arn, "*"),
                "Principal" => "*",
                "Condition" => {
                  "StringNotEquals" => {
                    "s3:x-amz-server-side-encryption" => "AES256"
                  }
                }
              },
              {
                "Sid" => "DenyUnEncryptedObjectUploads",
                "Action" => ["s3:PutObject"],
                "Effect" => "Deny",
                'Resource' => fn_join("/", bucket.arn, "*"),
                "Principal" => "*",
                "Condition" => {
                  "Null" => {
                    "s3:x-amz-server-side-encryption" => true
                  }
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
