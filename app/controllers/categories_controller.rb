class CategoriesController < ApplicationController
  before_action :authenticate_user!
  # Toda vez que o usuario envia alguma req, o before_action entra. Nesse caso, envia o token autenticado do user junto com a req. O devise intercepta e verifica se aquele usuario existe. ENtao ele pega esse usuario e coloca dentro da variavel current_user.

  before_action :set_category, only: %i[ show edit update destroy ]

  # GET /categories or /categories.json
  def index
    # método do pundit para usar o resolve dentro do scope
    @categories = policy_scope(Category)
    # o authorize não serve para index, pois ele é usado para verificar se o usuário tem permissão de acessar um registro específico, e no index é acessanda uma coleção de registros, e não um registro específico. por isso, tem que uar o policy_scope para filtrar os registros que o usuário tem permissão de acessar.
  end

  # GET /categories/1 or /categories/1.json
  def show
    authorize @category
  end

  # GET /categories/new
  def new
    @category = Category.new
    authorize @category
  end

  # GET /categories/1/edit
  def edit
    authorize @category
  end

  # POST /categories or /categories.json
  def create
    @category = current_user.categories.build(category_params)
    authorize @category

    respond_to do |format|
      if @category.save
        format.html { redirect_to root_path, notice: "Criado com sucesso." }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    authorize @category

    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to root_path, notice: "Atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    authorize @category

    @category.destroy!

    respond_to do |format|
      format.html { redirect_to categories_path, notice: "Category was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.expect(category: [ :title, :description ])
    end
end
