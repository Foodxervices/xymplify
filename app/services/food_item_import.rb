class FoodItemImport
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :user_id
  attr_accessor :restaurant_id
  attr_accessor :supplier_id
  attr_accessor :kitchen_ids
  attr_accessor :file

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def valid?
    if restaurant_id.blank?
      errors.add :base, "Restaurant need to be set."
      return false
    end

    if supplier_id.blank?
      errors.add :supplier_id, "Supplier need to be set."
      return false
    end

    if kitchen_ids.blank?
      errors.add :kitchen_ids, "please select a kitchen."
      return false
    end

    if file.nil?
      errors.add :file, "please upload the import file."
      return false
    end

    if File.extname(file.original_filename) != '.xlsx'
      errors.add :file, "Unknown file type: #{file.original_filename}"
      return false
    end

    return true
  end

  def save
    return false if !valid?

    all_success = true

    food_items = []

    xlsx = Roo::Excelx.new(file.path)
    sheet = xlsx.sheet(0)

    supplier = Supplier.find(supplier_id)

    i = 0
    sheet.each( code: "Item Code", name: "Item Name", brand: "Brand",
                unit_price_without_promotion: "Unit Price", unit_price: "Special Price", category: "Category",
                tag_list: "Item tags", country_of_origin: "Country of Origin" ) do |row|
      i += 1

      next if i == 1

      category_name = row[:category]
      row.delete(:category)

      food_item = FoodItem.find_or_initialize_by(code: row[:code], restaurant_id: restaurant_id)
      food_item.attributes  = row.to_hash.slice(*row.to_hash.keys)
      food_item.unit        = get_unit(food_item.name)
      food_item.user_id     = user_id
      food_item.supplier_id = supplier_id
      food_item.kitchen_ids = kitchen_ids
      food_item.unit_price_currency = supplier.currency if food_item.new_record?

      if category_name.present?
        category = Category.find_by_name(category_name)

        if category.nil?
          category = Category.find_or_create_by(name: 'Others')
          errors.add :warning, {row: i, message: "Food Item <b>#{food_item.code}</b> has been re-categorised as <b>Others</b>"}
        end

        food_item.category_id = category.id
      end

      if !food_item.save
        all_success = false

        food_item.errors.full_messages.each do |message|
          errors.add :import, {row: i, message: message}
        end
      end
    end

    all_success
  end

  def get_unit(name)
    name.downcase.scan( /([0-9]*[a-z]*) x/)&.last&.first
  end
end