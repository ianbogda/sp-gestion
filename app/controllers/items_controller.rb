class ItemsController < BackController

  navigation(:check_lists)

  before_filter :load_check_list
  before_filter :load_item, :except => [:new, :create]

  def new
    @item = @check_list.items.new
  end

  def create
    @item = @check_list.items.new(params[:item])
    if(@item.save)
      flash[:success] = "Le matériel a été créé."
      redirect_to(@check_list)
    else
      render(:action => :new)
    end
  end

  def edit
  end

  def update
    if @item.update_attributes(params[:item])
      flash[:success] = "Le matériel a été mis à jour."
      redirect_to(@check_list)
    else
      render(:action => :edit)
    end
  end

  def destroy
    @item.destroy
    flash[:success] = "Le matériel a été supprimé."
    redirect_to(@check_list)
  end

  private

  def load_check_list
    @check_list = @station.check_lists.find(params[:check_list_id])
   rescue ActiveRecord::RecordNotFound
     flash[:error] = "La liste n'existe pas."
    redirect_to(check_lists_path)
  end

  def load_item
    @item = @check_list.items.find(params[:id])
   rescue ActiveRecord::RecordNotFound
    flash[:error] = "Le matériel n'existe pas."
    redirect_to(check_list_path(@check_list))
  end

end