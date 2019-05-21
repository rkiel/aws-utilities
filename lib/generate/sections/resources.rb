module Generate

  class Resources

    def apply (data, items)
      data['resources'] ||= Hash.new
      data['resources']['Resources'] ||= Hash.new

      items.each do |item|
        resources = data['resources']['Resources']
        data['resources']['Resources'] = resources.merge(item.generate)
      end

      data
    end

  end # class

end # module
