require 'rails_helper'

describe FoodCategoriesController, :type => :controller do 
  let!(:user)         { create(:admin) }

  before { sign_in user }  

  describe '#index' do
    def do_request
      get :index
    end
   
    let!(:categories)        { create_list(:category, 2) }

    it 'renders the :index view' do
      do_request
      expect(assigns(:categories).size).to eq 2
      expect(response).to render_template :index
    end
  end

  describe '#new' do 
    def do_request
      get :new, format: :js
    end

    it 'assigns a new category and renders the :new view' do 
      do_request 
      expect(assigns(:category)).to be_a_new Category
      expect(response).to render_template :new
    end
  end

  describe '#create' do 
    def do_request
      post :create, category: category.attributes, format: :js
    end

    let(:category) { build(:category) }

    before do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it 'creates a category' do 
      expect{ do_request }.to change{ [Category.count] }.from([0]).to([1])
      expect(response).to redirect_to "where_i_came_from"
    end
  end

  describe '#edit' do 
    def do_request
      get :edit, id: category.id, format: :js
    end

    let!(:category) { create(:category) }

    it 'returns edit page' do
      do_request
      expect(assigns(:category)).to match category
      expect(response).to render_template :edit
    end
  end

  describe '#update' do 
    def do_request
      patch :update, id: category.id, category: { name: new_name }, format: :js
    end

    let!(:category)  { create(:category) }
    let!(:new_name)  { 'New Category Name' }

    before do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it 'updates category' do
      do_request
      expect(category.reload.name).to eq new_name
      expect(flash[:notice]).to eq 'Category has been updated.'
      expect(response).to redirect_to "where_i_came_from"
    end
  end

  describe '#destroy' do 
    def do_request
      delete :destroy, id: category.id
    end

    let!(:category) { create(:category) }

    before do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it 'deletes category' do 
      expect{ do_request }.to change{ Category.count }.from(1).to(0)
      expect(flash[:notice]).to eq('Category has been deleted.')
      expect(response).to redirect_to "where_i_came_from"
    end
  end

  describe '#update_priority' do 
    def do_request
      patch :update_priority, ids: [dried.id, oils.id]
    end

    let!(:dried) { create(:category, name: 'Dried', priority: 100) }
    let!(:oils)  { create(:category, name: 'Oils') }

    it 'updates category' do
      expect(dried.priority).to eq 100
      do_request
      expect(dried.reload.priority).to eq 1
      expect(oils.reload.priority).to eq 2
      expect(response).to render_template(nil)
    end
  end
end