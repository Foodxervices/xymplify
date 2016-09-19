class Permission < ActiveRecord::Base
  has_and_belongs_to_many :roles

  def self.write(class_name, cancan_action, name, description)
    permission  = Permission.where("subject_class = ? and action = ?", class_name, cancan_action).first

    if not permission
      permission = Permission.new
      permission.subject_class =  class_name
      permission.action = cancan_action
      permission.name = name
      permission.description = description
      permission.save
    else
      permission.name = name
      permission.description = description
      permission.save
    end
  end

  def self.eval_cancan_action(action)
    case action.to_s
    when "index", "show", "search"
      cancan_action = "read"
      action_desc = I18n.t :read
    when "create", "new"
      cancan_action = "create"
      action_desc = I18n.t :create
    when "edit", "update"
      cancan_action = "update"
      action_desc = I18n.t :edit
    when "delete", "destroy"
      cancan_action = "delete"
      action_desc = I18n.t :delete
    else
      cancan_action = action.to_s
      action_desc = "Other: " << cancan_action
    end
    return action_desc, cancan_action
  end
end
