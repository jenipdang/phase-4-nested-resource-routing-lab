class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :not_found

  #GET "/items" or "/users/:user_id/items"
  def index
    if params[:user_id]
      user = find_user
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  #GET "/items/:id" or "/users/:user_id/items/:id"
  def show
    item = find_item
    render json: item
  end

  #POST "/items" or "/users/:user_id/items"
  def create
    user = find_user
    item = user.items.create(item_params)
    render json: item, status: :created
  end

  private
  
  def find_user
    User.find(params[:user_id])
  end

  def find_item
    Item.find(params[:id])
  end

  def item_params
    params.permit(:name, :description, :price)
  end

  def not_found
    render json: { error: "User is not found" }, status: :not_found
  end

end
