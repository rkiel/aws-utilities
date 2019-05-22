require_relative './resource'

module Generate

  class Certificate < ::Generate::Resource

    attr_reader :settings

    def initialize(name, settings, suffix = 'Certificate')
      super(name, suffix)
      @settings = settings
    end

    def generate
      data = Hash.new
      data[name] = {
        'Type' => 'AWS::CertificateManager::Certificate',
        'Properties' => {
         'DomainName' => '${self:provider.stage}.${self:custom.domainName}',
         'DomainValidationOptions' => [
            {
              'DomainName' => '${self:provider.stage}.${self:custom.domainName}',
               'ValidationDomain' => '${self:provider.stage}.${self:custom.domainName}'
            }
          ]
        }
      }

      data
    end

  end # class

end # end
