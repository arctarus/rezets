module MailForm
  class Base
    # 1) Include attribute methods behavior
    include ActiveModel::AttributeMethods

    # 2) Define "clear_" as an attribute prefix
    attribute_method_prefix 'clear_'

    def self.attributes(*names)
      attr_accessor *names

      # 3) Ask to define the prefix methods for the given attributes names
      define_attribute_methods names
    end

    protected

    # 4) Since we declared a "clear_" prefix, it expects to have a
    # "clear_attribute" method defined, which receives an attribute
    # name and implements the clearing logic.
    def clear_attribute(attribute)
      send("#{attribute}=", nil)
    end

  end
end
