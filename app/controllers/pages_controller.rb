class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :is_my_page?, only: [:edit, :update, :destroy]

  # GET /pages
  # GET /pages.json
  def index
    form_keyword = params[:page].present? ? params[:page][:body] : nil
    keyword = form_keyword.gsub(' ','%') if form_keyword.present?

    @pages = Page.search(keyword).includes(:user).page(params[:page_no]).order('id desc')
    @search_form = Page.new(body: form_keyword)
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    @comments = @page.comments.includes(:user)
    @comment  = Comment.new(page_id: @page.id)
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(page_params)
    @page.user_id = current_user.id

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: 'Page was successfully created.' }
        format.json { render action: 'show', status: :created, location: @page }
      else
        format.html { render action: 'new' }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to pages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:title, :body, :tag, :user_name)
    end

    def is_my_page?
      unless @page.user_id == current_user.id
        flash[:error] =  "permission denied."
        redirect_to pages_path
      end
    end
end
