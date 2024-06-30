module HelperMethods
  def camelize_keys(obj)
    obj.deep_transform_keys { |key| key.to_s.camelize(:lower).to_sym }
  end
end
