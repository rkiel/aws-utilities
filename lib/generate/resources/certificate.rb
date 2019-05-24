require_relative './resource'

module Generate

  class Certificate < ::Generate::Resource

    def initialize(environment, name, suffix = 'Certificate')
      super(environment, name, suffix)
    end

    def generate
      data = Hash.new

      domain_name = "${self:custom.#{environment}.domain_name}"

      data[name] = {
        'Type' => 'AWS::CertificateManager::Certificate',
        'Properties' => {
         'DomainName' => domain_name,
         'DomainValidationOptions' => [
            {
              'DomainName' => domain_name,
              'ValidationDomain' => domain_name
            }
          ]
        }
      }

      data
    end

  end # class

end # end
