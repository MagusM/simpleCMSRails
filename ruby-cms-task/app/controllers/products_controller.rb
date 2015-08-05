class ProductsController < ApplicationController
  
  layout 'application'

  before_action :confirm_if_logged_in

  def index
    prdocuts_paginate_sorted
  end

  def show
    @product = Product.find(params[:id]) 
  end  

  def new
    @product = Product.new(name: "what is the product's name?", sku: 0, category: "which category this product belong to?")
  end

  def create
    @product = Product.new(product_params)
    if @product.valid?
      if @product.name.eql?("what is the product's name?") 
        @product.name = "Product Name"
      end
      if @product.category.eql?("which category this product belong to?")
        @product.category = "Category"
      end
        if @product.save
          flash[:notice] = "Product No.#{@product.id} successfully created"
          redirect_to({action: 'index'})
        else
          @product = Product.new(name: "what is the product's name?", sku: 0, category: "which category this product belong to?")
          render('new')
        end
    else
      render('new')
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(product_params)
      flash[:notice] = "Product No.#{@product.id} successfully updated"
      redirect_to(action: 'show', id: @product.id)
    else
      render('edit')
    end
  end

  def delete
    @product = Product.find(params[:id])
  end

  def destroy
    product = Product.find(params[:id]).destroy
    flash[:notice] = "Product No.#{product.id} successfully destroyed"
    redirect_to(action: 'index')
  end

  def close_alert
    alert_type = params[:alert_type]
    case alert_type
    when "condition"
      flash[:notice] = nil
    when "alert"
      flash[:alert] = nil
    end
    prdocuts_paginate_sorted
    render('index')
  end

  def close_error 
    page = params[:page]
    case page
    when "new"
      @product = Product.new(name: "what is the product's name?", sku: 0, category: "which category this product belong to?")
      render('new')  
    when "edit"
      @product = Product.find(params[:id])
      render('edit')
    end
  end

  def searchresults
    @products = search
  end

  def search_category
    cat = params[:cat]
    @products = Product.category(cat).paginate :per_page => 50, :page => params[:page]
    render('searchresults')
  end

  private 
    def product_params
      #like using params[:product], but this raises and error if :product is not presenet and allows listed attr to be mass-assigned
      params.require(:product).permit(:name, :sku, :category)
    end

  def search
    search_input = params[:search_input]
    
    if all_letters(search_input)
      products = Product.search(search_input).paginate :per_page => 50, :page => params[:page]
    elsif all_digits(search_input)
      search_input_num = search_input.to_i
      if Product.id_search(search_input_num).size == 0 
      flash[:alert] = "Product could not be found."
      redirect_to(action: 'index')
    end
      if (Product.id_search(search_input_num).length > 0)
        product = Product.id_search(search_input_num).paginate :per_page => 50, :page => params[:page]
      end
    end
  end

  def all_letters(str)
    str[/[a-zA-Z]+/]  == str
  end
  
  def all_digits(str)
    str[/[0-9]+/]  == str
  end

  def prdocuts_paginate_sorted
    @products = Product.id_sorted.paginate :per_page => 50, :page => params[:page]
  end

end
