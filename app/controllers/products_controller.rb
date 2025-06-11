class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy download_qr print_qr]

  # GET /products
  def index
    @products = Product.all
  end

  # GET /products/1
  def show
    require 'rqrcode'
    qr_data = "Name: #{@product.name}\nSKU: #{@product.sku}\nQty: #{@product.quantity}"
    @qr = RQRCode::QRCode.new(qr_data)
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit; end

  # POST /products
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

  # PATCH/PUT /products/1
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

  # DELETE /products/1
  def destroy
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to products_path, status: :see_other, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /products/:id/download_qr
  def download_qr
    require 'rqrcode'

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

  # GET /products/:id/print_qr
  def print_qr
    require 'rqrcode'

    qr_data = "Name: #{@product.name}\nSKU: #{@product.sku}\nQty: #{@product.quantity}"
    @qr = RQRCode::QRCode.new(qr_data)

    render layout: "print"
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :sku, :quantity, :expire_date, :initial_stock, :alert_email)
  end
 
  
end
