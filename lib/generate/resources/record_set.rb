require_relative './resource'

module Generate

  class RecordSet < ::Generate::Resource

    attr_reader :distribution

    def initialize(environment, name, distribution, suffix = 'RecordSet')
      super(environment, name, suffix)
      @distribution = distribution
    end

    def generate
      data = Hash.new
      data[name] = {
        'Type' => 'AWS::Route53::RecordSet',
        'Properties' => {
          'AliasTarget' => {
            'DNSName' => distribution.domain_name,
            'HostedZoneId' => '${self:custom.cfHostedZoneId}',
            'EvaluateTargetHealth' => false
          },
          'HostedZoneName' => '${self:custom.fqDomainName}',
          'Name' => "${self:custom.#{environment}.domain_name}",
          'Type' => 'A'
        }
      }

      data
    end

  end # class

end # end
