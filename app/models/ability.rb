class Ability
  include CanCan::Ability

  def initialize(user)
    user = (user ||= User.new)

    @kitchens = {}

    if user.kind_of?(Admin) 
      can :manage, :all
    elsif user.persisted?
      can :show, User
      can :read, Restaurant, { id: [] }
      can :read, Version
      can :update, Order
      can [:update_wip, :destroy], Order, { user_id: user.id, status: :wip }
      can :read, Role

      user.user_roles.includes(:role).each do |user_role|
        kitchen_ids = user_role.kitchens.any? ? user_role.kitchens.ids : Kitchen.where(restaurant_id: user_role.restaurant_id).ids
        
        can :read, Kitchen, { id: kitchen_ids }
      
        user_role.role.permissions.each do |permission|
          clazz, action = permission.split('__')
          action = action.to_sym
          
          case clazz 
            when 'restaurant'
              can action, clazz.camelize.constantize, { id: user_role.restaurant_id }
            when 'supplier', 'user_role', 'message'
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

    can [:mark_as_accepted, :mark_as_declined], Order do |order|
      order.status.placed?
    end

    cannot [:mark_as_delivered], Order do |order|
      !order.status.accepted?
    end

    cannot [:mark_as_cancelled], Order do |order|
      !order.status.placed? && !order.status.accepted?
    end
  end
end
