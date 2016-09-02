class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :index, :show,             :to => :read
    alias_action :new,                      :to => :create
    alias_action :edit,                     :to => :update

    @user = (user ||= User.new)

    can :manage, :all
  end
end
