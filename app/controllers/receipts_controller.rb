class ReceiptsController < ApplicationController
  before_action :set_receipt, only: [:show, :edit, :update, :destroy]
  before_action :set_edit_enabled, only: [:add_delivery, :add_delivery_receipt, :add_sales_invoice]

  # GET /receipts
  # GET /receipts.json
  def index
    @receipts = Receipt.all
  end

  # GET /receipts/1
  # GET /receipts/1.json
  def show
  end

  # GET /receipts/new
  def new
    @receipt = Receipt.new
  end

  def add_delivery
    @receipt = Receipt.new
    @receipt_type = Receipt::TYPES[:acquisition]
  end

  def add_delivery_receipt
    @receipt = Receipt.new
    @receipt_type = Receipt::TYPES[:delivery_receipt]
  end

  def add_sales_invoice
    @receipt = Receipt.new
    @receipt_type = Receipt::TYPES[:sales_invoice]
  end

  # GET /receipts/1/edit
  def edit
    @disabled = true
  end

  # POST /receipts
  # POST /receipts.json
  def create
    @receipt = Receipt.new(receipt_params)

    respond_to do |format|
      if @receipt.save
        @receipt.update_inventory
        format.html { redirect_to @receipt, notice: 'Receipt was successfully created.' }
        format.json { render :show, status: :created, location: @receipt }
      else
        format.html { render :new }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /receipts/1
  # PATCH/PUT /receipts/1.json
  def update
    respond_to do |format|
      if @receipt.update(receipt_params)
        format.html { redirect_to @receipt, notice: 'Receipt was successfully updated.' }
        format.json { render :show, status: :ok, location: @receipt }
      else
        format.html { render :edit }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receipts/1
  # DELETE /receipts/1.json
  def destroy
    @receipt.destroy
    respond_to do |format|
      format.html { redirect_to receipts_url, notice: 'Receipt was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_receipt
      @receipt = Receipt.find(params[:id])
      @receipt.date_issued = @receipt.date_issued.strftime("%m/%d/%Y")
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def receipt_params
      params[:receipt][:date_issued] = Date.strptime(params[:receipt][:date_issued], "%m/%d/%Y")
      params.require(:receipt).permit(
        :company_name, :receipt_number, :address, :date_issued, :total, :balance, :amount_received, :type,
        receipt_details_attributes: [:id, :_destroy, :qty, :unit, :unit_price, :total, :description, :part_number,
          item_attributes: [:id, :_destroy, :description, :part_number]]
      )
    end

    def set_edit_enabled
      @disabled = false
    end
end
