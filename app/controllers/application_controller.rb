class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # Adiciona o pundit para controle de autorização
  include Pundit::Authorization

  # ve se essa classe de erro específica vai subir.
  # se subir, ele cancela a tela de erro 500 e delega para o método privado.
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def user_not_authorized
    flash[:alert] = "Acesso negado. Você não tem permissão para realizar esta ação."

    # redireciona o usuario para a pagina ou raiz
    redirect_back(fallback_location: root_path)
  end
end
