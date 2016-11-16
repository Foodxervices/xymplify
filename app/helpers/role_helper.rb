module RoleHelper
  def get_permissions(role)
    result = {}
    Role.permissions.values.each do |permission|
      active = role.permissions.include?(permission)
      controller_name, action_name = t("enumerize.role.permissions.#{permission}").split('::').map(&:strip)
      result[controller_name] ||= []
      result[controller_name] << [action_name, active]
    end
    result
  end
end
