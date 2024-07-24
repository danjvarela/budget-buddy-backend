module ActiveModelSerializers
  module Adapter
    class WithData < Base
      def serializable_hash(options = nil)
        options = serialization_options(options)
        serialized_hash = {data: Attributes.new(serializer, instance_options).serializable_hash(options)}

        self.class.transform_key_casing!(serialized_hash, instance_options)
      end
    end
  end
end

ActiveModelSerializers.config.key_transform = :camel_lower
ActiveModelSerializers.config.adapter = :with_data
