require_relative './resource'

module Generate

  class RecordSet < ::Generate::Resource

    attr_reader :settings, :distribution

    def initialize(name, settings, distribution, suffix = 'RecordSet')
      super(name, suffix)
      @settings = settings
      @distribution = distribution
    end

    def generate
      data = Hash.new
      data[name] = {
        'Type' => 'AWS::Route53::RecordSet',
        'Properties' => {
          'AliasTarget' => {
            'DNSName' => distribution.domain_name,
            'HostedZoneId' => '${self:custom.hostedZoneId}'
          },
          'HostedZoneName' => '${self:custom.FQDN}',
          'Name' => '${self:provider.stage}.${self:custom.domainName}',
          'Type' => 'A'
        }
      }

      data
    end

  end # class

end # end
