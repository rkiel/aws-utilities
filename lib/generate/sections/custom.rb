module Generate

  class Custom

    def apply (data, settings)
      data['custom'] ||= Hash.new

      defaults = {
        'defaultStage' => 'dev',
        'cfHostedZoneId' => 'Z2FDTNDATAQYW2'
      }

      data['custom'] = defaults.merge(data['custom'])
      data['custom'] = data['custom'].merge(settings)
      data['custom']['FQDN'] = data['custom']['domainName']+'.'

      data
    end

  end # class

end # module
