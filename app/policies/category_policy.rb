class CategoryPolicy < ApplicationPolicy
  
    def update?
        record.user_id == user.id
        # so atualiza se for o dono da categoria
    end

    def destroy?
        record.user_id == user.id
        # so deleta se for o dono da categoria
    end
end
