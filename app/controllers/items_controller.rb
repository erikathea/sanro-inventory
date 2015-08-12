class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy, :merge]
  helper InventoriesHelper
  respond_to :html

  def index
    @items = Item.includes(:inventories).all
    respond_with(@items)
  end

  def generate_report
  end

  def show
    respond_with(@item)
  end

  def new
    authorize Item
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
    Item.all.each do |item|
      ajaxList << "#{item.description} #{item.part_number} |#{item.id}"
    end
    respond_to do |format|
      format.html
      format.json{ render json: ajaxList }
    end
  end

  def getStock
    @item = Item.includes(:inventories).find(params[:id])
    respond_to do |format|
      format.json{ render json: @item.total_stock }
    end
  end

  def getUnitPrice
    @item = Item.find(params[:id])
    respond_to do |format|
      format.json{ render json: @item.unit_price }
    end
  end

  def merging
    @items = []
    params[:items].split(',').sort().each do |id|
      @items << Item.find(id).clone
    end

    @merged = Item.merge_preview(@items)
    respond_with(@items)
  end

  def merge
    # TODO: clean params[:items]
    # mass update is faster with raw sql
    remarks = ""
    params[:items].each do |id|
      item = Item.find(id)
      item.update(remarks: "Merged to #{@item.description} - #{@item.part_number}(#{@item.id})", description: "MERGED[#{item.description}]")
      remarks += " Merged: #{item.description} - #{item.part_number}(#{id}); "

      merge_item = MergeItem.create(from: id, to: @item.id)
      ids = Inventory.where(item_id: id).map(&:id)
      ids.each do |obj_id|
        MergeTransaction.connection.execute "INSERT INTO merge_transactions(mergeable_id, mergeable_type, merge_item_id, created_at, updated_at) VALUES (#{obj_id}, 'Inventory', #{merge_item.id}, '#{DateTime.now.to_s(:db)}', '#{DateTime.now.to_s(:db)}')"
      end

      ids = OutgoingReceiptDetail.where(item_id: id).map(&:id)
      ids.each do |obj_id|
        MergeTransaction.connection.execute "INSERT INTO merge_transactions(mergeable_id, mergeable_type, merge_item_id, created_at, updated_at) VALUES (#{obj_id}, 'OutgoingReceiptDetail', #{merge_item.id}, '#{DateTime.now.to_s(:db)}', '#{DateTime.now.to_s(:db)}')"
      end

      ids = IncomingReceiptDetail.where(description: item.description, part_number: item.part_number).map(&:id)
      ids.each do |obj_id|
        MergeTransaction.connection.execute "INSERT INTO merge_transactions(mergeable_id, mergeable_type, merge_item_id, created_at, updated_at) VALUES (#{obj_id}, 'IncomingReceiptDetail', #{merge_item.id}, '#{DateTime.now.to_s(:db)}', '#{DateTime.now.to_s(:db)}')"
      end

      Inventory.connection.execute "UPDATE inventories SET item_id = #{@item.id} where item_id = #{id}"
      OutgoingReceiptDetail.connection.execute "UPDATE outgoing_receipt_details SET item_id = #{@item.id} where item_id = #{id}"
      IncomingReceiptDetail.connection.execute "UPDATE incoming_receipt_details SET description = '#{@item.description}', part_number = '#{@item.part_number}' where description = '#{item.description}' AND part_number = '#{item.part_number}'"
    end

    @item.update(remarks: "#{@item.remarks}; #{remarks}")
    respond_with(@item)
  end

  private
    def set_item
      @item = Item.includes(:inventories).find(params[:id])
      authorize @item
    end

    def item_params
      params.require(:item).permit(
        :description,
        :part_number,
        :remarks,
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
