class OutgoingReceiptDetailsController < ApplicationController
  before_action :set_outgoing_receipt_detail, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @outgoing_receipt_details = OutgoingReceiptDetail.all
    respond_with(@outgoing_receipt_details)
  end

  def show
    respond_with(@outgoing_receipt_detail)
  end

  def new
    @outgoing_receipt_detail = OutgoingReceiptDetail.new
    respond_with(@outgoing_receipt_detail)
  end

  def edit
  end

  def create
    @outgoing_receipt_detail = OutgoingReceiptDetail.new(outgoing_receipt_detail_params)
    @outgoing_receipt_detail.save
    respond_with(@outgoing_receipt_detail)
  end

  def update
    @outgoing_receipt_detail.update(outgoing_receipt_detail_params)
    respond_with(@outgoing_receipt_detail)
  end

  def destroy
    @outgoing_receipt_detail.destroy
    respond_with(@outgoing_receipt_detail)
  end

  private
    def set_outgoing_receipt_detail
      @outgoing_receipt_detail = OutgoingReceiptDetail.find(params[:id])
    end

    def outgoing_receipt_detail_params
      params.require(:outgoing_receipt_detail).permit(:outgoing_receipt_id, :total, :qty, :unit, :inventory_id)
    end
end
