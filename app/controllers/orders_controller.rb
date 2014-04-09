class OrdersController < ApplicationController
	before_filter :authorise, :only =>[:new, :create]
	
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
	#@orders = Order.shipped 	# Show only the shipped orders

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # Shows the customers' orders, if they are signed in.
  def customerorders
	@customer = Customer.find_by_id(session[:customer_id])
	@orders = @customer.orders
	if !@orders.empty?
		render 'index'
	else
		redirect_to :index
  end
 end
  
  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.json
  def new
	@cart = current_cart
	if @cart.lineitems.empty?
	redirect_to root_path, notice: "Your cart is empty"
	return
	end
    @order = Order.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  
  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(params[:order])
	@order.add_lineitems_from_cart(current_cart)
	@order.customer_id = @current_customer.id
    respond_to do |format|
      if @order.save
			Cart.destroy(session[:cart_id])
			session[:cart_id] = nil
			format.html { redirect_to root_path, notice: 'Thank you for your order' }
			format.json { render json: @order, status: :created, location: @order }
      else
			@cart = current_cart
			format.html { render action: "new" }
			format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end


  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :ok }
    end
  end
end