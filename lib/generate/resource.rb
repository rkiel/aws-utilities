module Generate

  class Resource

    def fn_get_attr (attr)
      { 'Fn::GetAtt' => attr }
    end

    def fn_join (delim, *items)
      { 'Fn::Join' => [delim, items] }
    end

    def fn_ref (name)
      { 'Ref' => name }
    end
    
  end

end
