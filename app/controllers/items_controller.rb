class ItemsController < ApplicationController
  def list_description
    respond_to do |format|
      format.html
      format.json{ render json: Item.pluck(:description)}
    end
  end

  def list_part_number
    respond_to do |format|
      format.html
      format.json{ render json: Item.pluck(:part_number)}
    end
  end
end