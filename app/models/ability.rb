class Ability
  include CanCan::Ability

  def initialize(user)
    @kitchens = {}

    if user.kind_of?(Admin) 
      can :manage, :all
    else
      can :read, Restaurant, { id: [] }
      
      user.user_roles.includes(:role).each do |user_role|
        kitchen_ids = user_role.kitchens.any? ? user_role.kitchens.ids : user_role.restaurant.kitchens.ids
        
        can :read, Kitchen, { id: kitchen_ids }

        user_role.role.permissions.each do |permission|
          clazz, action = permission.split('__')
          action = action.to_sym
          
          case clazz 
            when 'restaurant'
              can action, clazz.camelize.constantize, { id: user_role.restaurant_id }
            when 'supplier', 'user_role'
              can action, clazz.camelize.constantize, { restaurant_id: user_role.restaurant_id }
            when 'food_item'
              can action, clazz.camelize.constantize, { kitchen_id: kitchen_ids }
            when 'kitchen'
              can action, clazz.camelize.constantize, { id: kitchen_ids }
          end
        end
      end
    end
  end
end
