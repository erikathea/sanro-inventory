class IncomingReceiptDetailsController < ApplicationController
  before_action :set_incoming_receipt_detail, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @incoming_receipt_details = IncomingReceiptDetail.all
    respond_with(@incoming_receipt_details)
  end

  def show
    respond_with(@incoming_receipt_detail)
  end

  def new
    @incoming_receipt_detail = IncomingReceiptDetail.new
    respond_with(@incoming_receipt_detail)
  end

  def edit
  end

  def create
    @incoming_receipt_detail = IncomingReceiptDetail.new(incoming_receipt_detail_params)
    @incoming_receipt_detail.save
    respond_with(@incoming_receipt_detail)
  end

  def update
    @incoming_receipt_detail.update(incoming_receipt_detail_params)
    respond_with(@incoming_receipt_detail)
  end

  def destroy
    @incoming_receipt_detail.destroy
    respond_with(@incoming_receipt_detail)
  end

  private
    def set_incoming_receipt_detail
      @incoming_receipt_detail = IncomingReceiptDetail.find(params[:id])
    end

    def incoming_receipt_detail_params
      params.require(:incoming_receipt_detail).permit(:incoming_receipt_id, :description, :part_number, :total, :unit_price, :qty, :unit)
    end
end
