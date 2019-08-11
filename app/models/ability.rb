class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?
      can :manage, :all
      cannot :index, [Building, Unit, Review, NeighborhoodLink, Contact, Upload]
      cannot [:contribution, :index], User
      cannot [:index, :new, :edit], ManagementCompany
      cannot [:index, :show, :saved_buildings], User
      cannot [:index, :create, :update, :destroy], [BrokerFeePercent, RentMedian, FeaturedComp]
      cannot [:index, :add_or_update_prices], Price
      cannot :manage, Listing
    elsif user.has_role? :admin
      can :manage, :all
    else
      can :manage, :all
      cannot :index, [Building, Unit, Review, NeighborhoodLink, Contact, Upload]
      cannot [:contribution, :index], User
      cannot [:index, :new, :edit], ManagementCompany
      cannot [:index, :create, :update, :destroy], [BrokerFeePercent, RentMedian, FeaturedComp]
      cannot [:index, :add_or_update_prices], Price
    end
  end
  
end
