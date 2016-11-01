class VersionFilter
  include ActiveModel::Model

  attr_accessor :item_type
  attr_accessor :item_types
  attr_accessor :events
  attr_accessor :event
  attr_accessor :attributes
  attr_accessor :date_range

  def initialize(versions, attrs = {})
    @versions = versions
    attrs.each { |name, value| send("#{name}=", value) }
    @item_types = []
    @events = []
    
    @versions.select('item_type, event').map do |version|
      @item_types << version.item_type
      @events << version.event
    end

    @item_types = @item_types.uniq.map{|kclass| [kclass.constantize.model_name.human, kclass.constantize]}
    @events = @events.uniq.map{|event| [event.humanize, event]}
  end


  def attribute_list
    arr = {}
    item_types.each do |class_name, kclass|
      arr[class_name] = kclass.column_names.map{|column| [kclass.human_attribute_name(column), "#{kclass.name}:#{column}"] }
    end
    arr
  end

  def result
    @versions = @versions.where(item_type: item_type) if item_type.present?

    @versions = @versions.where(event: event) if event.present?

    if attributes.present?
      conditions = []
      attribute_values.each do |attr|
        if item_type.constantize.column_names.include?(attr)
          conditions << " versions.object_changes ILIKE '%#{attr}:%' "
        end
      end
      @versions = @versions.where(conditions.join("OR"))
    end

    if date_range.present?
      from, to = date_range.split(' - ')
      @versions = @versions.where(created_at: (Date.strptime(from, '%m/%d/%Y').beginning_of_day..Date.strptime(to, '%m/%d/%Y').end_of_day))
    end

    @versions 
  end

  def attribute_values
    attributes.map{|attr| attr.split(':')[1]}
  end

  def persisted?
    false
  end
end