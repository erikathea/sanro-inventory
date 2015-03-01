class OutgoingReceiptsController < ApplicationController
  before_action :set_outgoing_receipt, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @outgoing_receipts = OutgoingReceipt.all
    respond_with(@outgoing_receipts)
  end

  def show
    respond_with(@outgoing_receipt)
  end

  def new
    @outgoing_receipt = OutgoingReceipt.new
    respond_with(@outgoing_receipt)
  end

  def edit
  end

  def create
    @outgoing_receipt = OutgoingReceipt.new(outgoing_receipt_params)
    @outgoing_receipt.save
    respond_with(@outgoing_receipt)
  end

  def update
    @outgoing_receipt.update(outgoing_receipt_params)
    respond_with(@outgoing_receipt)
  end

  def destroy
    @outgoing_receipt.destroy
    respond_with(@outgoing_receipt)
  end

  private
    def set_outgoing_receipt
      @outgoing_receipt = OutgoingReceipt.find(params[:id])
    end

    def outgoing_receipt_params
      params.require(:outgoing_receipt).permit(:receipt_number, :client, :address, :date_issued, :total, :amount_received, :balance, :type)
    end
end
