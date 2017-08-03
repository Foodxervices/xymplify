class RequisitionFilter
  include ActiveModel::Model

  DATE_FORMAT = '%d/%m/%Y'

  attr_accessor :keyword
  attr_accessor :supplier_id
  attr_accessor :date_range
  attr_accessor :start_date
  attr_accessor :end_date

  def initialize(requisitions, attributes = {})
    @requisitions = requisitions
    attributes.each { |name, value| send("#{name}=", value) }
    @date_range = default_date_range if !date_range.present?
    from, to    = date_range.split(' - ')
    @start_date = Date.strptime(from, DATE_FORMAT)
    @end_date   = Date.strptime(to, DATE_FORMAT)
  end

  def result
    @requisitions =  @requisitions.uniq.joins("LEFT JOIN requisition_items ri ON ri.requisition_id = requisitions.id")
                                  .joins("LEFT JOIN users u ON requisitions.user_id = u.id")
                                  .joins("LEFT JOIN food_items f ON f.id = ri.food_item_id")

    if keyword.present?
      @requisitions = @requisitions.where("
                                        f.code               ILIKE :keyword OR
                                        f.name               ILIKE :keyword OR
                                        u.name               ILIKE :keyword
                                      ", keyword: "%#{keyword}%")
    end

    if supplier_id.present?
      @requisitions = @requisitions.where('f.supplier_id = ?', supplier_id)
    end

    @requisitions = @requisitions.where(updated_at: (start_date.beginning_of_day..end_date.end_of_day))

    @requisitions
  end

  def persisted?
    false
  end

  def default_date_range
    from = Time.now.beginning_of_month.strftime(DATE_FORMAT)
    to = Time.now.end_of_month.strftime(DATE_FORMAT)
    "#{from} - #{to}"
  end
end