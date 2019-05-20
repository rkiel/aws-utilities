module Generate

  class Resource

    attr_reader :name

    def initialize(name, suffix)
      @name = "#{name}#{suffix}"
    end
    
    def fn_get_attr (attr)
      { 'Fn::GetAtt' => attr }
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
      fn_get_attr(name+'.Arn')
    end

  end

end
