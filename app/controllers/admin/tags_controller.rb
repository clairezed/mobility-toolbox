# frozen_string_literal: true

class Admin::TagsController < Admin::BaseController
  before_action :find_tag, only: %i(edit update position destroy)

  def index
    params[:sort] ||= 'sort_by_title asc'
    @tags = Tag.apply_filters(params)
    respond_to do |format|
      format.html do
        @tags = @tags.paginate(per_page: 20, page: params[:page])
      end
      format.json do
        # format spécifique à select2
        render json: @tags.limit(5).map { |tag| { id: tag.id, text: tag.title } }
      end
    end
  end

  def new
    @tag = Tag.new
    @tag.build_seo
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      flash[:notice] = 'Le mot-clé a été créé avec succès'
      redirect_to params[:continue].present? ? edit_admin_tag_path(@tag) : admin_tags_path
    else
      flash[:error] = "Une erreur s'est produite lors de la création du mot-clé"
      render :new
    end
  end

  def edit; end

  def update
    if @tag.update_attributes(tag_params)
      flash[:notice] = 'Le mot-clé a été mis à jour avec succès'
      redirect_to params[:continue].present? ? edit_admin_tag_path(@tag) : admin_tags_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour du mot-clé"
      render :edit
    end
  end

  def position
    if params[:position].present?
      @tag.insert_at params[:position].to_i
      flash[:notice] = 'Les mot-clés ont été réordonnés avec succès'
    end
    redirect_to admin_tags_path
  end

  def destroy
    begin
      flash[:notice] = 'Le mot-clé a été supprimé avec succès' if @tag.destroy
    rescue ActiveRecord::DeleteRestrictionError
      flash[:error] = 'Ce mot-clé ne peut être supprimé car des éléments lui sont dépendants'
    end
    redirect_to admin_tags_path
  end

  private

  def find_tag
    @tag = Tag.from_param params[:id]
  end

  # strong parameters
  def tag_params
    params.require(:tag).permit(:title, :enabled, seo_attributes: %i(slug title keywords description id))
  end
end
