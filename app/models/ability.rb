class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?
      can :manage, :all
      cannot :index, [Building, Unit, Review, Contact, Upload]
      cannot [:delete, :create, :documents], Upload
      cannot [:contribution, :index, :managertools, :agenttools, :frbotools], User
      cannot [:index, :new, :edit], [ManagementCompany, FeaturedAgent, FeaturedBuilding, FeaturedListing]
      cannot [:index, :show, :saved_buildings], User
      cannot [:index, :create, :update, :destroy, :new], [BrokerFeePercent, RentMedian, FeaturedComp, NeighborhoodLink, FeaturedBuilding, VideoTour, FeaturedListing]
      cannot [:index, :add_or_update_prices], Price
      cannot :manage, [Listing, Price]
    elsif user.has_role? :admin
      can :manage, :all
    else
      can :manage, :all
      cannot :index, [Building, Unit, Review, Contact, Upload, FeaturedBuilding, FeaturedAgent, FeaturedListing]
      cannot :documents, Upload
      cannot [:contribution, :index], User
      cannot [:index, :new, :edit], ManagementCompany
      cannot [:index, :create, :update, :destroy], [BrokerFeePercent, RentMedian, FeaturedComp, NeighborhoodLink, VideoTour]
      cannot [:index, :add_or_update_prices], Price
      cannot :manage, [Listing, Price]
    end
  end
  
end
