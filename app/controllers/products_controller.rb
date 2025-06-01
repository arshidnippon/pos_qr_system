class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    @products = Product.all
  end

  # GET /products/1 or /products/1.json
  def show
    @product = Product.find(params[:id])
    require 'rqrcode'
    qr_data = "Name: #{@product.name}\nSKU: #{@product.sku}\nQty: #{@product.quantity}"
    @qr = RQRCode::QRCode.new(qr_data)
  end
  

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to products_path, status: :see_other, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def download_qr
    @product = Product.find(params[:id])
    qr_data = "Name: #{@product.name}\nSKU: #{@product.sku}\nQty: #{@product.quantity}"
    qr = RQRCode::QRCode.new(qr_data)

  
    png = qr.as_png(
      resize_gte_to: false,
      resize_exactly_to: false,
      fill: 'white',
      color: 'black',
      size: 300,
      border_modules: 4,
      module_px_size: 6,
      file: nil # return as string
    )
  
    send_data png.to_s,
              type: 'image/png',
              disposition: 'attachment',
              filename: "#{@product.name.parameterize}-qr.png"
  end
  
  def print_qr
    @product = Product.find(params[:id])
    require 'rqrcode'
    qr_data = "Name: #{@product.name}\nSKU: #{@product.sku}\nQty: #{@product.quantity}"
    @qr = RQRCode::QRCode.new(qr_data)
    render layout: "print"
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :sku, :quantity, :expire_date)
    end
end
