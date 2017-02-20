class Admin::AxesController < Admin::BaseController

  before_action :find_axis, only: [ :edit, :update, :position, :destroy ]

  def index
    params[:sort] ||= "sort_by_position asc"
    @axes = Axis.apply_filters(params).paginate(per_page: 20, page: params[:page])
  end

  def new
    @axis = Axis.new
    @axis.build_seo
  end
  
  def create
    @axis = Axis.new(axis_params)
    if @axis.save
      flash[:notice] = "L'axe a été créé avec succès"
      redirect_to params[:continue].present? ? edit_admin_axis_path(@axis) : admin_axes_path
    else
      flash[:error] = "Une erreur s'est produite lors de la création de l'axe"
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @axis.update_attributes(axis_params)
      flash[:notice] = "L'axe a été mis à jour avec succès"
      redirect_to params[:continue].present? ? edit_admin_axis_path(@axis) : admin_axes_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'axe"
      render :edit
    end
  end
  
  def position
    if params[:position].present?
      @axis.insert_at params[:position].to_i 
      flash[:notice] = "Les axes ont été réordonnés avec succès"
    end
    redirect_to admin_axes_path
  end

  def destroy
    @axis.destroy
    flash[:notice] = "L'axe a été supprimé avec succès"
    redirect_to admin_axes_path
  end


  private

  def find_axis
    @axis = Axis.from_param params[:id]
  end

  # strong parameters
  def axis_params
    params.require(:axis).permit(:title, :description, :theme_id, :enabled, seo_attributes: [:slug, :title, :keywords, :description, :id])
  end
  
end