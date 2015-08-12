class ItemPolicy < ApplicationPolicy
  def merge?
    update?
  end
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end
