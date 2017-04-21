module ChangesList extend ActiveSupport::Concern
  included do
    def changes_list
      list = []

      changes.each do |field, values|
        list << "#{self.class.human_attribute_name(field)} was changed from #{values[0]} to #{values[1]}"
      end

      list
    end
  end
end
