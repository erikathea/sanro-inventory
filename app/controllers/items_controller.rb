class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @items = Item.includes(:inventories).all
    respond_with(@items)
  end

  def show
    respond_with(@item)
  end

  def new
    @item = Item.new
    respond_with(@item)
  end

  def edit
  end

  def create
    @item = Item.new(item_params)
    @item.save
    respond_with(@item)
  end

  def update
    @item.update(item_params)
    respond_with(@item)
  end

  def destroy
    @item.destroy
    respond_with(@item)
  end

  def descriptions
    respond_to do |format|
      format.html
      format.json{ render json: Item.pluck(:description).uniq }
    end
  end

  def part_numbers
    respond_to do |format|
      format.html
      format.json{ render json: Item.where(description: params[:description].upcase).pluck(:part_number).uniq }
    end
  end

  def ajaxList
    ajaxList = []
    Item.pluck(:description, :part_number).uniq.each do |item|
      ajaxList << "#{item.first} - #{item.last}"
    end
    respond_to do |format|
      format.html
      format.json{ render json: ajaxList }
    end
  end
  private
    def set_item
      @item = Item.find(params[:id])
    end

    def item_params
      params.require(:item).permit(
        :description,
        :part_number,
        :selling_price,
        inventories_attributes: [
          :id,
          :_destroy,
          :unit_price,
          :current_stock
        ]
      )
    end
end
