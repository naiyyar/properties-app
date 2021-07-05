class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil? || !user.admin?
      can :manage, :all
      cannot :index, [Building, Upload]
      cannot [:delete, :create], Upload
      cannot [:contribution, :index], User
      cannot [:index, :new, :edit], [ManagementCompany, FeaturedBuilding]
      cannot [:index, :show, :saved_buildings], User
      cannot [:index, :create, :update, :destroy, :new], [Review, FeaturedBuilding]
      cannot :manage, [Listing]
    else
      can :manage, :all
    end
  end
  
end
