require_relative './resource'

module Generate

  class Oai < ::Generate::Resource
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def key
      name
    end

    def generate
      data = Hash.new
      data[name] = {
        'Type' => 'AWS::CloudFront::CloudFrontOriginAccessIdentity',
        'Properties' => {
          'CloudFrontOriginAccessIdentityConfig' => {
            'Comment' => '${self:service}-${opt:stage}'
          }
        }
      }

      data
    end
  end # class

end # module
