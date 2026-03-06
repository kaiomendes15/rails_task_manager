class Admin::UsersController < ApplicationController
 
  before_action :authenticate_user!

  before_action :require_admin 

  before_action :set_user, only: %i[edit update destroy]

  def index
    
    @users = User.all.order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      redirect_to admin_users_path, notice: "Usuário criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # TRUQUE DE ARQUITETURA: 
    # Se o admin deixou a senha em branco na hora de editar, 
    # nós removemos esses campos do parâmetro para o Rails não tentar salvar uma senha vazia.
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update(user_params)
      redirect_to admin_users_path, notice: "Usuário atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Regra de negócio: Um admin não pode excluir a própria conta acidentalmente
    if @user == current_user
      redirect_to admin_users_path, alert: "Você não pode excluir a sua própria conta."
    else
      @user.destroy
      redirect_to admin_users_path, notice: "Usuário excluído com sucesso."
    end
  end

  private

  # O Segurança da Área VIP
  def require_admin
    unless current_user.is_admin?
      redirect_to root_path, alert: "Acesso negado. Área restrita para administradores."
    end
  end

  def set_user
    @user = User.find(params.expect(:id))
  end

  # Parâmetros permitidos para a manipulação manual de usuários
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :is_admin)
  end
end