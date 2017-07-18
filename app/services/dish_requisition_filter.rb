class DishRequisitionFilter
  include ActiveModel::Model

  DATE_FORMAT = '%d/%m/%Y'

  attr_accessor :keyword
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
    @requisitions =  @requisitions.uniq.joins("LEFT JOIN dish_requisition_items ri ON ri.dish_requisition_id = dish_requisitions.id")
                                  .joins("LEFT JOIN users u ON dish_requisitions.user_id = u.id")
                                  .joins("LEFT JOIN dishes d ON d.id = ri.dish_id")

    if keyword.present?
      @requisitions = @requisitions.where("
                                        d.name               ILIKE :keyword OR
                                        u.name               ILIKE :keyword
                                      ", keyword: "%#{keyword}%")
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