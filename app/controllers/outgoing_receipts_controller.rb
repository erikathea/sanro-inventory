class OutgoingReceiptsController < ApplicationController
  before_action :set_outgoing_receipt, only: [:show, :edit, :update, :destroy]
  respond_to :html

  def index
    @outgoing_receipts = OutgoingReceipt.all
    respond_with(@outgoing_receipts)
  end

  def sales_invoices
    @outgoing_receipts = OutgoingReceipt.where(sale_type: 0)
    @type = 'Sales Invoices (SI)'
    render 'index'
  end

  def deliveries
    @outgoing_receipts = OutgoingReceipt.where(sale_type: 1)
    @type = 'Delivery Receipts (DR)'
    render 'index'
  end

  def generate_report
    @outgoing_receipts = OutgoingReceipt.all
    render 'index'
  end

  def show
    respond_with(@outgoing_receipt)
  end

  def new
    authorize OutgoingReceipt
    @outgoing_receipt = OutgoingReceipt.new
    respond_with(@outgoing_receipt)
  end

  def add_si
    @outgoing_receipt = OutgoingReceipt.new
    @outgoing_receipt.sale_type = 0
    render :new
  end

  def add_dr
    @outgoing_receipt = OutgoingReceipt.new
    @outgoing_receipt.sale_type = 1
    render :new
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
      @outgoing_receipt = OutgoingReceipt.includes(:outgoing_receipt_details).find(params[:id])
      @outgoing_receipt.date_issued = @outgoing_receipt.date_issued.strftime("%d/%m/%Y")
      authorize @outgoing_receipt
    end

    def outgoing_receipt_params
      params.require(:outgoing_receipt).permit(
        :receipt_number,
        :po_no,
        :client,
        :address,
        :date_issued,
        :total,
        :amount_received,
        :balance,
        :sale_type,
        outgoing_receipt_details_attributes: [
          :id,
          :_destroy,
          :total,
          :qty,
          :unit,
          :selling_price,
          :item_id
        ]
      )
    end
end
