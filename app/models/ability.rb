class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?
      can :manage, :all
      cannot :index, Building
      cannot :index, Unit
      cannot :index, Review
      cannot [:contribution, :index], User
      cannot :index, Contact
    elsif user.has_role? :admin
      can :manage, :all
    else
      can :manage, :all
      cannot :index, Building
      cannot :index, Unit
      cannot :index, Review
      cannot [:contribution, :index], User
      cannot :index, Contact
    end
  end
end
