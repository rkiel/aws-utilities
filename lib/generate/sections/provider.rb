module Generate

  class Provider

    def apply (data)
      data['provider'] ||= Hash.new

      defaults = {
        'name' => 'aws',
        'runtime' => 'nodejs10',
        'stage' => "${opt:stage, self:custom.defaultStage}"
      }

      data['provider'] = defaults.merge(data['provider'])

      data
    end

  end # class

end # module
