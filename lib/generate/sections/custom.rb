module Generate

  class Custom

    def apply (data, settings)
      data['custom'] ||= Hash.new

      defaults = {
        'defaultStage' => 'dev',
        'cfHostedZoneId' => 'Z2FDTNDATAQYW2'
      }

      data['custom'] = defaults.merge(data['custom']) # keep any pre-existing custom values

      data['custom']['domainName'] = settings['domainName']
      data['custom']['serviceName'] = settings['serviceName']
      data['custom']['fqDomainName'] = settings['domainName']+'.'

      settings['environments'].each do |environment|
        custom = data['custom']
        custom[environment] ||= Hash.new
        custom[environment]['bucket_name'] = "${self:custom.serviceName}-#{environment}"

        parts = []
        parts << environment unless environment == settings['productionName']
        parts << ['${self:custom.domainName}']
        custom[environment]['domain_name'] = parts.join('.')
      end

      data
    end

  end # class

end # module
