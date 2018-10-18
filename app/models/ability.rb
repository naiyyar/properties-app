class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?
      can :manage, :all
      cannot :index, Building
      cannot :index, Unit
      cannot :index, Review
      cannot [:contribution, :index], User
      cannot :index, NeighborhoodLink
      cannot :index, Contact
      cannot [:index, :new, :edit], ManagementCompany
      cannot [:index, :show, :saved_buildings], User
    elsif user.has_role? :admin
      can :manage, :all
    else
      can :manage, :all
      cannot :index, Building
      cannot :index, Unit
      cannot :index, Review
      cannot [:contribution, :index], User
      cannot :index, NeighborhoodLink
      cannot :index, Contact
      cannot [:index, :new, :edit], ManagementCompany
    end
  end
  
end
