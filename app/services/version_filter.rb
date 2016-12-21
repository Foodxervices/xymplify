class VersionFilter
  include ActiveModel::Model

  DATE_FORMAT = '%d/%m/%Y'

  attr_accessor :item_type
  attr_accessor :item_types
  attr_accessor :events
  attr_accessor :event
  attr_accessor :attributes
  attr_accessor :date_range
  attr_accessor :start_date
  attr_accessor :end_date

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

    @date_range = default_date_range if !date_range.present?
    from, to    = date_range.split(' - ')
    @start_date = Date.strptime(from, DATE_FORMAT)
    @end_date   = Date.strptime(to, DATE_FORMAT)
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

    @versions = @versions.where(created_at: (start_date.beginning_of_day..end_date.end_of_day))

    @versions 
  end

  def attribute_values
    attributes.map{|attr| attr.split(':')[1]}
  end

  def default_date_range
    from = Time.zone.now.beginning_of_month.strftime(DATE_FORMAT)
    to = Time.zone.now.end_of_month.strftime(DATE_FORMAT)
    "#{from} - #{to}"
  end

  def persisted?
    false
  end
end