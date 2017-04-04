class ContactsController < AdminController
  load_and_authorize_resource
  layout :layout_by_action

  def index
    @contact_filter = ContactFilter.new(filter_params)
    @contacts = @contact_filter.result.paginate(:page => params[:page])
  end

  def show
    @contact = Contact.find(params[:id])
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      redirect_to new_contact_path, notice: 'Thank you for your submission. We will get back to you as soon as posible.'
    else
      render :new
    end
  end

  def destroy
    if @contact.destroy
      flash[:notice] = 'Contact has been deleted.'
    else
      flash[:notice] = @contact.errors.full_messages.join("<br />")
    end

    redirect_to :back
  end

  private

  def layout_by_action
    ["new", "create"].include?(action_name) ? 'public/layouts/main' : 'main'
  end

  def contact_params
    params.require(:contact).permit(
      :name,
      :email,
      :designation,
      :organisation,
      :your_query
    )
  end

  def filter_params
    contact_filter = ActionController::Parameters.new(params[:contact_filter])

    contact_filter.permit(
      :keyword
    )
  end
end