class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :new_attachment, :to => :add_attachment
    alias_action :confirm_delivery, :deliver, :to => :mark_as_delivered

    user = (user ||= User.new)

    can :create, Contact

    @kitchens = {}

    if user.kind_of?(Admin)
      can :manage, :all
      cannot :manage, nil
    elsif user.persisted?
      can :show, User
      can :show, Role
      can :show, Category
      can :read, Restaurant, { id: [] }
      can :read, Version
      can :update, Order
      can [:update_wip, :update_confirmed, :destroy], Order, { user_id: user.id, status: ['wip', 'confirmed'] }

      user.user_roles.includes(:role).each do |user_role|
        kitchen_ids = user_role.kitchens.any? ? user_role.kitchens.ids : Kitchen.where(restaurant_id: user_role.restaurant_id).ids

        can :read, Kitchen, { id: kitchen_ids }

        user_role.role.permissions.each do |permission|
          clazz, action = permission.split('__')
          action = action.to_sym

          case clazz
            when 'restaurant'
              can action, clazz.camelize.constantize, { id: user_role.restaurant_id }
            when 'supplier', 'user_role', 'message', 'food_item', 'dish'
              can action, clazz.camelize.constantize, { restaurant_id: user_role.restaurant_id }
            when 'order', 'inventory', 'requisition'
              can action, clazz.camelize.constantize, { kitchen_id: kitchen_ids }
            when 'kitchen'
              if action == :create
                can action, clazz.camelize.constantize, { restaurant_id: user_role.restaurant_id }
              else
                can action, clazz.camelize.constantize, { id: kitchen_ids }
              end
          end
        end
      end

      cannot [:update_priority], Supplier
    end

    cannot [:show], FoodItem do |food_item|
      food_item.deleted?
    end

    cannot [:pay], Order do |order|
      order.status.pending? || order.status.rejected? || order.status.declined?
    end

    cannot [:mark_as_approved, :mark_as_rejected], Order do |order|
      !order.status.pending? && !order.status.confirmed?
    end

    cannot [:mark_as_accepted, :mark_as_declined], Order do |order|
      !order.status.placed?
    end

    cannot [:deliver], Order do |order|
      !order.status.accepted?
    end

    cannot [:mark_as_cancelled], Order do |order|
      !order.status.placed? && !order.status.accepted?
    end
  end
end
