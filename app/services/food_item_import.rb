class FoodItemImport
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :user_id
  attr_accessor :kitchen_id
  attr_accessor :supplier_name
  attr_accessor :file

  def initialize(attributes = {})
    @supplier_name = 'FoodXervices'
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def valid?
    if kitchen_id.blank?
      errors.add :kitchen_id, "please select a kitchen."
      return false
    end

    if file.nil?
      errors.add :file, "please upload the import file."
      return false
    end

    return false if !imported_food_items

    if !imported_food_items.map(&:valid?).all?
      imported_food_items.each_with_index do |food_item, index|
        food_item.errors.full_messages.each do |message|
          errors.add :import, {row: index+2, message: message}
        end
      end

      return false
    end

    return true
  end

  def save
    if valid?
      imported_food_items.map(&:save)

      return true
    end

    return false
  end

  def imported_food_items
    @imported_food_items ||= load_imported_food_items
  end

  def load_imported_food_items
    spreadsheet = open_spreadsheet

    return false if !spreadsheet

    if spreadsheet.first.size != food_item_attributes.size
      errors.add :file, "The file is not in the right format"
      return false
    end

    header = food_item_attributes

    food_items = []
    restaurant = Kitchen.find(kitchen_id).restaurant
    supplier = Supplier.find_or_create_by(name: supplier_name, restaurant_id: restaurant.id)
    category = Category.find_by_name('Others')

    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      food_item = FoodItem.find_or_initialize_by(code: row["code"], kitchen_id: kitchen_id)
      food_item.attributes  = row.to_hash.slice(*row.to_hash.keys)
      food_item.unit        = get_unit(food_item.name)
      food_item.supplier    = supplier if food_item.new_record?
      food_item.user_id     = user_id
      food_item.kitchen_id  = kitchen_id
      food_item.category_id = category.id
      food_item.unit_price_currency = "" if food_item.new_record?
      food_items << food_item 
    end

    food_items
  end

  def get_unit(name)
    name.downcase.scan( /([0-9]*[a-z]*) x/)&.last&.first
  end

  def open_spreadsheet
    if File.extname(file.original_filename) == '.csv' 
      Roo::CSV.new(file.path)
    else 
      errors.add :file, "Unknown file type: #{file.original_filename}"
      return false
    end
  end

  def food_item_attributes
    ["code", "name", "brand", "unit_price"]
  end
end