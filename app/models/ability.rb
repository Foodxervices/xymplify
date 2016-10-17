class Ability
  include CanCan::Ability

  def initialize(user)
    @kitchens = {}

    if user.kind_of?(Admin) 
      can :manage, :all
    else
      can :show, User
      can :read, Restaurant, { id: [] }
      can :read, Version
      can :update, Order
      can [:update_wip, :destroy], Order, { user_id: user.id, status: :wip }
      
      user.user_roles.includes(:role, :restaurant).each do |user_role|
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
            when 'order'
              can action, clazz.camelize.constantize, { kitchen_id: kitchen_ids }
            when 'kitchen'
              can action, clazz.camelize.constantize, { id: kitchen_ids }
          end
        end
      end
    end

    cannot [:mark_as_shipped, :mark_as_cancelled], Order do |order|
      !order.status.placed?
    end
  end
end
