module Generate

  class Custom

    def apply (data, json_hash)
      data['custom'] ||= Hash.new

      defaults = {
        'defaultStage' => 'dev'
      }

      data['custom'] = defaults.merge(data['custom']) # keep any pre-existing custom values

      custom = data['custom']

      ['domainName', 'serviceName', 'cfHostedZoneId'].each do |field|
        custom[field] = "${file(./serverless.json):#{field}}"
      end
      custom['fqDomainName'] = '${self:custom.domainName}.'

      json_hash['environments'].each do |environment|
        custom[environment] ||= Hash.new
        custom[environment]['bucket_name'] = "${self:custom.serviceName}-#{environment}"

        domain_name_parts = []
        domain_name_parts << environment unless environment == json_hash['productionName']
        domain_name_parts << ['${self:custom.domainName}']
        custom[environment]['domain_name'] = domain_name_parts.join('.')
      end

      data
    end

  end # class

end # module
