# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    user_owner_of_record?
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    user_owner_of_record?
  end

  def edit?
    update?
  end

  def destroy?
    user_owner_of_record?
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      # raise NoMethodError, "You must define #resolve in #{self.class}"
      @scope.where(user_id: @user.id)
    end

    private

    attr_reader :user, :scope
  end

  private

  def user_owner_of_record?
    @record.user_id == @user.id
  end
end
