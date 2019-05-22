module Generate

  class Resource

    attr_reader :name, :environment, :settings

    def initialize(environment, name, suffix, settings)
      @name = "#{name}#{suffix}#{environment.upcase}"
      @environment = environment
      @settings = settings
    end

    def setPath(object, path, value)
      parts = path.split('.')
      something(object, parts, value)
    end

    def fn_get_attr (*attr)
      { 'Fn::GetAtt' => attr.join('.') }
    end

    def fn_join (delim, *items)
      { 'Fn::Join' => [delim, items] }
    end

    def fn_ref (name)
      { 'Ref' => name }
    end

    def ref
      fn_ref(name)
    end

    def arn
      fn_get_attr(name, 'Arn')
    end

  private

    def something (object, paths, value)
      if paths.empty?
        return value
      else
        key = paths.shift
        object[key] = object[key] == nil ? Hash.new : object[key]
        object[key] = something(object[key], paths, value)
        object
      end
    end
  end

end
