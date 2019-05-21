module Generate

  class Custom

    def apply (data)
      data['custom'] ||= Hash.new

      defaults = {
        'defaultStage' => 'dev'
      }

      data['custom'] = defaults.merge(data['custom'])

      data
    end

  end # class

end # module
