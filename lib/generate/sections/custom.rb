module Generate

  class Custom

    def apply (data, settings)
      data['custom'] ||= Hash.new

      defaults = {
        'defaultStage' => 'dev'
      }

      data['custom'] = defaults.merge(data['custom']) # keep any pre-existing custom values

      data['custom']['domainName'] = '${file(./serverless.json).domainName}'
      data['custom']['serviceName'] = '${file(./serverless.json).serviceName}'
      data['custom']['cfHostedZoneId'] = '${file(./serverless.json).cfHostedZoneId}'
      data['custom']['fqDomainName'] = '${self:custom.domainName}.'

      settings['environments'].sort.each do |environment|
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
