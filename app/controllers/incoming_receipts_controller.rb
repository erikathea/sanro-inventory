class IncomingReceiptsController < ApplicationController
  before_action :set_incoming_receipt, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @incoming_receipts = IncomingReceipt.all
    respond_with(@incoming_receipts)
  end

  def show
    respond_with(@incoming_receipt)
  end

  def new
    @incoming_receipt = IncomingReceipt.new
    respond_with(@incoming_receipt)
  end

  def edit
  end

  def create
    @incoming_receipt = IncomingReceipt.new(incoming_receipt_params)
    @incoming_receipt.save
    respond_with(@incoming_receipt)
  end

  def update
    @incoming_receipt.update(incoming_receipt_params)
    respond_with(@incoming_receipt)
  end

  def destroy
    @incoming_receipt.destroy
    respond_with(@incoming_receipt)
  end

  private
    def set_incoming_receipt
      @incoming_receipt = IncomingReceipt.find(params[:id])
    end

    def incoming_receipt_params
      params.require(:incoming_receipt).permit(:receipt_number, :supplier, :address, :date_issued, :total, :amount_received, :balance)
    end
end
